const DOTFILES_ROOT = '~/source/dotfiles'
const STATE_FILE = $"($nu.cache-dir)/chezmoi-state.nuon" | path expand
const MAPPINGS_FILE = path self ./mappings.nuon

# Manage dotfiles à la chezmoi, with extra features to handle multiple OS setups
# 
# chezmoi est chez toi
export def main [] {
}


export def "sync" [direction: string --dry-run --verbose] {
  if not ($direction in ['apply' 'pull']) {
    
  }

  let mappings = get-mappings
  mut state = load-state
  for m in $mappings {
    if (should-skip $m) { continue }
    let files = enumerate-files $m
    for file in $files {
      mut source_hash = file-hash $file.source
      mut target_hash = file-hash $file.target
      mut last_applied_hash = $state | get -o $file.target

      mut source_missing = $source_hash == null
      mut target_missing = $target_hash == null
      mut source_matches_target = $source_hash == $target_hash
      mut target_changed_only = (
        $source_hash == $last_applied_hash and $target_hash != $last_applied_hash
      )
      let source_changed_only = (
        $source_hash != $last_applied_hash and $target_hash == $last_applied_hash
      )
      let both_changed = (
        $source_hash != $last_applied_hash
        and $target_hash != $last_applied_hash
      )
    }
  }
}

export def "apply" [--dry-run --verbose] {
  let mappings = get-mappings
  mut state = load-state
  for m in $mappings {
    if (should-skip $m) { continue }

    let files = enumerate-files $m

    for file in $files {
      let source_hash = file-hash $file.source
      let target_hash = file-hash $file.target
      let last_applied_hash = $state | get -o $file.target

      let source_missing = $source_hash == null
      let target_missing = $target_hash == null
      let source_matches_target = $source_hash == $target_hash
      let target_changed_only = (
        $source_hash == $last_applied_hash and $target_hash != $last_applied_hash
      )
      let source_changed_only = (
        $source_hash != $last_applied_hash and $target_hash == $last_applied_hash
      )
      let both_changed = (
        $source_hash != $last_applied_hash
        and $target_hash != $last_applied_hash
      )

      if $target_missing {
        let target_dir = $file.target | path dirname
        if not ($target_dir | path exists) {
          if not $dry_run {
            mkdir $target_dir
          }
          print $" mkdir ($target_dir)"
        }

        if not $dry_run {
          cp $file.source $file.target
          $state = ($state | upsert $file.target $source_hash)
        }
        print $" cp ($file.source) ($file.target)"
        continue
      }

      if $source_missing {
        # TODO treat deletion cases
        print $"⚠ SKIP : source missing for target : ($file.target)"  
        continue
      }

      if $source_matches_target {
        if $source_hash != $last_applied_hash {
          if not $dry_run {
            $state = ($state | upsert $file.target $source_hash)
          }
        }
        if $verbose {
          print $"✓ ($file.target) - up to date"
        }
        continue
      }

      if $source_changed_only {
        let target_dir = $file.target | path dirname
        if not ($target_dir | path exists) {
          if not $dry_run {
            mkdir $target_dir
          }
          print $" mkdir ($target_dir)"
        }

        if not $dry_run {
          cp $file.source $file.target
          $state = ($state | upsert $file.target $source_hash)
        }
        print $" cp ($file.source) ($file.target)"
        continue
      }

      if $target_changed_only {
        print $"⚠ SKIP ($file.target) - local changes detected \(run 'pull' to save)"
        continue
      }

      if $both_changed {
        if $source_hash == $target_hash {
          if not $dry_run {
            $state = ($state | upsert $file.target $source_hash)
          }
          if $verbose {
            print $"✓ ($file.target) - identical after changes"
          }
        } else {
          print $"⚠ CONFLICT ($file.target) - both source and target changed \(resolve manually)"
        }
        continue
      }
    }
  }

  if not $dry_run {
    save-state $state
  }
  
  print "\n✓ Apply complete"
}

export def "pull" [--dry-run --verbose] {
  let mappings = get-mappings
  mut state = load-state

  for m in $mappings {
    if (should-skip $m) { continue }

    let files = enumerate-files $m

    for file in $files {
      let source_hash = file-hash $file.source
      let target_hash = file-hash $file.target
      let last_applied_hash = $state | get -o $file.target

      let target_missing = $target_hash == null
      let source_missing = $source_hash == null
      let source_matches_target = $source_hash == $target_hash
      let source_changed_only = (
        $source_hash != $last_applied_hash and $target_hash == $last_applied_hash
      )
      let target_changed_only = (
        $source_hash == $last_applied_hash and $target_hash != $last_applied_hash
      )
      let both_changed = (
        $source_hash != $last_applied_hash and $target_hash != $last_applied_hash
      )

      if $source_missing {
        let source_dir = $file.source | path dirname
        if not ($source_dir | path exists) {
          if not $dry_run {
            mkdir $source_dir
          }
          print $" mkdir ($source_dir)"
        }

        if not $dry_run {
          cp $file.target $file.source
          $state = ($state | upsert $file.target $target_hash)
        }
        print $" cp ($file.target) ($file.source)"
        continue
      }

      if $target_missing {
        print $"⚠ SKIP : target missing for source : ($file.source)"
        continue
      }

      if $source_matches_target {
        if $source_hash != $last_applied_hash {
          if not $dry_run {
            $state = ($state | upsert $file.target $source_hash)
          }
        }
        if $verbose {
          print $"✓ ($file.source) - up to date"
        }
        continue
      }

      if $source_changed_only {
        print $"⚠ SKIP ($file.source) - remote/source changed (run 'apply' to update)"
        continue
      }

      if $target_changed_only {
        let source_dir = $file.source | path dirname
        if not ($source_dir | path exists) {
          if not $dry_run {
            mkdir $source_dir
          }
          print $" mkdir ($source_dir)"
        }

        if not $dry_run {
          cp $file.target $file.source
          $state = ($state | upsert $file.target $target_hash)
        }
        print $" cp ($file.target) ($file.source)"
        continue
      }

      if $both_changed {
        if $source_hash == $target_hash {
          if not $dry_run {
            $state = ($state | upsert $file.target $source_hash)
          }
          if $verbose {
            print $"✓ ($file.source) - identical after changes"
          }
        } else {
          print $"⚠ CONFLICT ($file.source) - both source and target changed (resolve manually)"
        }
        continue
      }
    }
  }

  if not $dry_run {
    save-state $state
  }

  print "\n✓ Pull complete"
}

def file-hash [path: string] {
  if not ($path | path exists) { return null }
  open --raw $path | hash sha256
}

def get-mappings [] {
  $MAPPINGS_FILE | open
}

def should-skip [mapping: record] {
  let os = $nu.os-info.name
  let only_list = $mapping | get -o only | default []
  ($only_list | is-not-empty) and not ($only_list | any {|x| $x == $os})
}
 
def resolve-target [mapping: record] {
  if ($mapping.target | describe -d | get type) == 'record' {
    $mapping.target | get -o $nu.os-info.name
  } else {
    $mapping.target
  } 
}

def load-state [] {
  if not ($STATE_FILE | path exists) { return {} }
  open $STATE_FILE
}

def save-state [state: record] {
  let state_dir = $STATE_FILE | path dirname
  if not ($state_dir | path exists) { mkdir $state_dir }
  $state | save -f $STATE_FILE
}

def enumerate-files [mapping: record] {
  let target_relative = resolve-target $mapping
  if $target_relative == null { return [] }

  let target = $target_relative | path expand -n
  let source = $"($DOTFILES_ROOT)/($mapping.source)"

  if not ($source | path exists) { return [] }

  let is_dir = ($source | path type) == 'dir'

  if not $is_dir {
    return [{
      source: ($source | path expand -n),
      target: $target,
      mapping: $mapping
    }]
  }

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

