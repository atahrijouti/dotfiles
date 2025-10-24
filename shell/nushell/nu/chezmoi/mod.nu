const DOTFILES_ROOT = '~/source/dotfiles'
const STATE_FILE = $"($nu.cache-dir)/chezmoi-state.nuon" | path expand
const MAPPINGS_FILE = path self ./mappings.nuon

# Manage dotfiles à la chezmoi, with extra features to handle multiple OS setups
# 
# chezmoi est chez toi
export def main [] {
}

export def "apply" [--dry-run --verbose] {
  let $vd = $verbose or $dry_run

  let mappings = get-mappings
  mut state = load-state
  for m in $mappings {
    if (should-skip $m) { continue }

    let files = enumerate-files $m

    for file in $files {
      let source_hash = file-hash $file.source
      let target_hash = file-hash $file.target
      let last_applied_hash = $state | get -o $file.target

      let target_exists = $target_hash != null
      let target_changed_since_last_apply = $target_hash != $last_applied_hash
      let source_changed_since_last_apply = $source_hash != $last_applied_hash
      let is_first_time = $last_applied_hash == null
      let source_matches_target = $source_hash == $target_hash

      if not $target_exists {
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

      } else if $is_first_time {
        if $source_matches_target {
          if not $dry_run {
            $state = ($state | upsert $file.target $source_hash)
          }
          if $verbose {
            print $"✓ ($file.target) - already matches"
          }
        } else {
          print $"⚠ SKIP ($file.target) - exists with different content \(run 'pull' first or remove file)"
        }
      } else if not $source_changed_since_last_apply and not $target_changed_since_last_apply {
        if $verbose {
          print $"✓ ($file.target) - up to date"
        }
      } else if not $source_changed_since_last_apply and $target_changed_since_last_apply {
        print $"⚠ SKIP ($file.target) - local changes detected \(run 'pull' to save)"
      } else if $source_changed_since_last_apply and not $target_changed_since_last_apply {
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
      } else {
        print $"⚠ CONFLICT ($file.target) - both source and target changed \(resolve manually)"
      }
    }
  }

  save-state $state
  print "\n✓ Apply complete"
}

export def "pull" [--dry-run] {
  let mappings = get-mappings

  for m in $mappings {
    if (should-skip $m) { continue }

    let target_relative = resolve-target $m
    if $target_relative == null { continue }

    let target = $target_relative | path expand -n
    let source = $DOTFILES_ROOT | path join $m.source 
    
    # Check if target exists
    if not ($target | path exists) {
      print $"⚠ Skipped ($m.source) - target not found: ($target)"
      continue
    }

    let target_files = if ($target | path type) == file {
      [ $target ]
    } else if ($target | path type) == dir { 
      let excludes_attribute = $m | get -o excludes | default []
      let includes_attribute = $m | get -o includes | default []
      if ($includes_attribute | is-not-empty) {
        $includes_attribute | each {|pattern|
          glob $"($target_relative)/($pattern)" --no-dir
        } | flatten
      } else {
        # the extra __never_match__/** is because glob won't allow me to pass in just one pattern that doesn't use `foldername/**`
        let exclude_patterns = $excludes_attribute | append '__never_match__/**'
        glob $"($target_relative)/**/*" --no-dir --exclude $exclude_patterns 
        # print $exclude_patterns
        # []
      }
    } else {
      []
    }

    if ($target_files | is-empty) {
      print $"⚠ No files to pull from ($target)"
      continue
    }

    # Copy each file back to source
    for target_file in $target_files {
      let source_path = if ($target | path type ) == file {
        $source
      } else {
        let relative_path = $target_file | path relative-to $target
        $source | path join $relative_path 
      } | path expand -n

      let source_dir = $source_path | path dirname
      if not ($source_dir | path exists) {
          mkdir $source_dir
          print $"✓ mkdir ($source_dir)"
      }
      print $"cp ($target_file) ($source_path)"
      if not $dry_run {
        cp $target_file $source_path
      }
    }
  }
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

