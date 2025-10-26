const DOTFILES_ROOT = '~/source/dotfiles'
const STATE_FILE = $"($nu.cache-dir)/chezmoi-state.nuon" | path expand
const MAPPINGS_FILE = path self ./mappings.nuon
const POSSIBLE_DIRECTIONS = ['apply', 'pull']

# Manage dotfiles à la chezmoi, with extra features to handle multiple OS setups
# 
# chezmoi est chez toi
export def main [] {
}

export def apply [--dry-run --verbose] {
  sync apply --dry-run=$dry_run --verbose=$verbose
}

export def pull [--dry-run --verbose] {
  sync pull --dry-run=$dry_run --verbose=$verbose
}

export def status [--verbose] {
  mut changes = []
  let mappings = get-mappings
  mut state = load-state
  for m in $mappings {
    if (os-skippable $m) { continue }
    let files = enumerate-files $m
    for file in $files {
      let source_hash = file-hash $file.source
      let target_hash = file-hash $file.target
      let last_applied_hash = $state | get -o $file.target
      let source_matches_target = $source_hash == $target_hash

      let source_status = match $source_hash {
        null => 'missing',
        $last_applied_hash => 'unchanged',
        _ => 'changed'
      }

      let target_status = match $target_hash {
        null => 'missing',
        $last_applied_hash => 'unchanged',
        _ => 'changed'
      }

      if $file.target == 'C:\Users\atj\AppData\Roaming\nushell\nu\chezmoi\mod.nu' {
        print {
          hash: $target_hash,
          last_has: $last_applied_hash
        }
      }

      
      if $source_status != 'unchanged' or $target_status != 'unchanged' or $verbose {
        $changes ++= [{
          source_status: $source_status,
          source: $file.source
          target_status: $target_status,
          target: $file.target
        }]
      }
    }
  }

  $changes
}

export def sync [direction: string --dry-run --verbose] {
  if not ($direction in $POSSIBLE_DIRECTIONS) {
    print $"direction takes ($POSSIBLE_DIRECTIONS), received ($direction)"
    return 
  }

  let is_apply = $direction == 'apply'

  let mappings = get-mappings
  mut state = load-state
  for m in $mappings {
    if (os-skippable $m) { continue }
    let files = enumerate-files $m
    for file in $files {
      let from = if $is_apply { $file.source } else { $file.target }
      let to = if $is_apply { $file.target } else { $file.source }

      let from_locale = if $is_apply {'source'} else {'local'}
      let to_locale = if $is_apply {'local'} else {'source'}

      let from_hash = file-hash $from
      let to_hash = file-hash $to

      let last_applied_hash = $state | get -o $file.target

      let from_missing = $from_hash == null
      let to_missing = $to_hash == null
      let from_matches_to = $from_hash == $to_hash
      let to_changed_only = (
        $from_hash == $last_applied_hash and $to_hash != $last_applied_hash
      )
      let from_changed_only = (
        $from_hash != $last_applied_hash and $to_hash == $last_applied_hash
      )
      let both_changed = (
        $from_hash != $last_applied_hash
        and $to_hash != $last_applied_hash
      )

      # TODO treat deletion cases
      if $to_missing {
        let to_dir = $to | path dirname
        if not ($to_dir | path exists) {
          if not $dry_run {
            mkdir $to_dir
          }
          print $" mkdir ($to_dir)"
        }

        if not $dry_run {
          cp $from $to
          $state = ($state | upsert $file.target $from_hash)
        }
        print $" cp ($from) ($to)"
        continue
      }

      # TODO treat deletion cases
      if $from_missing {
        print $"⚠ SKIP : ($from_locale) file missing for ($to_locale) file : ($from)"  
        continue
      }

      if $from_matches_to {
        if $from_hash != $last_applied_hash {
          if not $dry_run {
            $state = ($state | upsert $file.target $from_hash)
          }
        }
        if $verbose {
          print $"✓ ($to) - up to date"
        }
        continue
      }

      if $from_changed_only {
        let to_dir = $to | path dirname
        if not ($to_dir | path exists) {
          if not $dry_run {
            mkdir $to_dir
          }
          print $" mkdir ($to_dir)"
        }

        if not $dry_run {
          cp $from $to
          $state = ($state | upsert $file.target $from_hash)
        }
        print $" cp ($from) ($to)"
        continue
      }

      if $to_changed_only {
        if $is_apply {
          print $"⚠ SKIP ($to) - local changes detected \(run 'pull' to save)"
        } else {
          print $"⚠ SKIP ($to) - source changes detected \(run 'apply' to update)"
        }
        continue
      }

      if $both_changed {
        if $from_hash == $to_hash {
          if not $dry_run {
            $state = ($state | upsert $file.target $from_hash)
          }
          if $verbose {
            print $"✓ ($to) - identical after changes"
          }
        } else {
          print $"⚠ CONFLICT ($to) - both source and local files changed \(resolve manually)"
        }
        continue
      }
    }
  }

  if not $dry_run {
    save-state $state
  }

  print $"\n✓ ($direction | str capitalize) complete"
}

def file-hash [path: string] {
  if not ($path | path exists) { return null }
  open --raw $path | hash sha256
}

def get-mappings [] {
  $MAPPINGS_FILE | open
}

def os-skippable [mapping: record] {
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

