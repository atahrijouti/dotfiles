# State file location
  const STATE_FILE = '~/.cache/chezmoi-nu/state.nuon'

  # Helper: compute file hash
  def file-hash [path: string] {
    if not ($path | path exists) { return null }
    open --raw $path | hash sha256
  }

  # Helper: load state
  def load-state [] {
    let state_path = $STATE_FILE | path expand
    if not ($state_path | path exists) { return {} }
    open $state_path
  }

  # Helper: save state
  def save-state [state: record] {
    let state_path = $STATE_FILE | path expand
    let state_dir = $state_path | path dirname
    if not ($state_dir | path exists) { mkdir $state_dir }
    $state | save -f $state_path
  }

  # Enumerate files for a mapping (used by both apply and pull)
  def enumerate-files [mapping: record, dotfiles_root: string] {
    let target_relative = resolve-target $mapping
    if $target_relative == null { return [] }

    let target = $target_relative | path expand -n
    let source = $dotfiles_root | path join $mapping.source

    # Check if source exists
    if not ($source | path exists) { return [] }

    let is_dir = ($source | path type) == 'dir'

    if not $is_dir {
      # Single file mapping
      return [{
        source: $source,
        target: $target,
        mapping: $mapping
      }]
    }

    # Directory mapping - enumerate with includes/excludes
    let source_relative = $mapping.source
    let excludes = $mapping | get -o excludes | default []
    let includes = $mapping | get -o includes | default []

    let files = if ($includes | is-not-empty) {
      $includes | each {|pattern|
        glob $"($source)/($pattern)" --no-dir
      } | flatten
    } else {
      let exclude_patterns = $excludes | append '__never_match__/**'
      glob $"($source)/**/*" --no-dir --exclude $exclude_patterns
    }

    $files | each {|file|
      let relative = $file | path relative-to $source
      {
        source: $file,
        target: ($target | path join $relative | path expand -n),
        mapping: $mapping
      }
    }
  }

  export def "apply" [] {
    let mappings = get-mappings
    let dotfiles_root = $nu.home-path | path join source dotfiles
    mut state = load-state

    for m in $mappings {
      if (should-skip $m) { continue }

      let files = enumerate-files $m $dotfiles_root

      for file in $files {
        let source_hash = file-hash $file.source
        let target_hash = file-hash $file.target
        let last_applied = $state | get -o $file.target

        # Decision logic
        if $target_hash == $last_applied {
          # Target unchanged since last apply - safe to overwrite
          let target_dir = $file.target | path dirname
          if not ($target_dir | path exists) {
            mkdir $target_dir
            print $"✓ mkdir ($target_dir)"
          }

          print $"→ cp ($file.source) ($file.target)"
          cp -f $file.source $file.target
          $state = ($state | upsert $file.target $source_hash)

        } else if $target_hash == null {
          # Target doesn't exist - create it
          let target_dir = $file.target | path dirname
          if not ($target_dir | path exists) {
            mkdir $target_dir
            print $"✓ mkdir ($target_dir)"
          }

          print $"→ cp ($file.source) ($file.target)"
          cp -f $file.source $file.target
          $state = ($state | upsert $file.target $source_hash)

        } else if $last_applied == null {
          # Never applied before, but target exists
          if $source_hash == $target_hash {
            # They're the same - just record state
            print $"✓ ($file.target) - already matches"
            $state = ($state | upsert $file.target $source_hash)
          } else {
            # Different - warn about overwrite
            print $"⚠ SKIP ($file.target) - exists with different content (run 'pull' first or remove file)"
          }

        } else {
          # Target was modified locally
          if $source_hash == $last_applied {
            # Source unchanged, target changed - local edits
            print $"⚠ SKIP ($file.target) - local changes detected (run 'pull' to save)"
          } else if $source_hash == $target_hash {
            # Somehow they match now - just update state
            print $"✓ ($file.target) - already matches"
            $state = ($state | upsert $file.target $source_hash)
          } else {
            # Both changed - conflict!
            print $"⚠ CONFLICT ($file.target) - both source and target changed (resolve manually)"
          }
        }
      }
    }

    save-state $state
    print "\n✓ Apply complete"
  }

  export def "pull" [] {
    # Add git pull first
    print "→ git pull"
    cd ($nu.home-path | path join source dotfiles)
    git pull

    let mappings = get-mappings
    let dotfiles_root = $nu.home-path | path join source dotfiles
    mut state = load-state

    for m in $mappings {
      if (should-skip $m) { continue }

      let files = enumerate-files $m $dotfiles_root

      for file in $files {
        if not ($file.target | path exists) {
          print $"⚠ SKIP ($file.source) - target not found: ($file.target)"
          continue
        }

        let source_dir = $file.source | path dirname
        if not ($source_dir | path exists) {
          mkdir $source_dir
          print $"✓ mkdir ($source_dir)"
        }

        print $"← cp ($file.target) ($file.source)"
        cp -f $file.target $file.source

        # Update state after pull
        let new_hash = file-hash $file.source
        $state = ($state | upsert $file.target $new_hash)
      }
    }

    save-state $state
    print "\n✓ Pull complete"
  }
