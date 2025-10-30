const DOTFILES_ROOT = '~/source/dotfiles'
const STATE_FILE = $"($nu.cache-dir)/chezmoi-state.nuon" | path expand
const MAPPINGS_FILE = path self ./mappings.nuon
const POSSIBLE_DIRECTIONS = ['apply', 'pull']
const OS = $nu.os-info.name

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
    let files = enumerate-mapping-files $m
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

export def status [--verbose] {
  mut status_data = workable-files | each {|f| mapping-state-and-metadata $f (load-state) }

  if not $verbose {
    $status_data = $status_data | where {|f| $f.status != 'up-to-date' }
  }

  $status_data
}

# last_applied == null
# - untracked-both-missing      : source == null and target == null  
# - untracked-source-missing    : target != null and source == null  
# - untracked-target-missing    : source != null and target == null  
# - untracked-different         : source != target and target != null and source != null  
# - untracked-identical         : source == target and source != null
# last_applied != null
# - both-deleted                  : source == null and target == null
# - source-deleted                : source == null and target == last_applied  
# - source-deleted-target-changed : source == null and target != last_applied  
# - target-deleted                : source == last_applied and target == null  
# - target-deleted-source-changed : target == null and source != last_applied 
# - source-changed                : source != last_applied and target == last_applied 
# - target-changed                : target != last_applied and source == last_applied 
# - both-changed-different        : target != last_applied and source != last_applied and target != source
# - both-changed-identical        : source != last_applied  and target != last_applied and source == target 
# - up-to-date                    : source == last_applied and target == last_applied 

def mapping-state [source: oneof<string, nothing>, target: oneof<string, nothing>, last: oneof<string, nothing>] {
  if $last == null {
    match [$source, $target] {
      [null, null] => 'untracked-both-missing'
      [null, _]    => 'untracked-source-missing'
      [_, null]    => 'untracked-target-missing'
      [$s, $t] if $s == $t => 'untracked-identical'
      [$s, $t] if $s != $t => 'untracked-different'
    }
  } else {
    match [$source, $target] {
      [null, null] => 'both-deleted'
      [null, $t] if $t == $last => 'source-deleted'
      [null, $t] if $t != $last => 'source-deleted-target-changed'
      [$s, null] if $s == $last => 'target-deleted'
      [$s, null] if $s != $last => 'target-deleted-source-changed'
      [$s, $t] if $s != $last and $t == $last => 'source-changed'
      [$s, $t] if $s == $last and $t != $last => 'target-changed'
      [$s, $t] if $s != $last and $t != $last and $s == $t => 'both-changed-identical'
      [$s, $t] if $s != $last and $t != $last and $s != $t => 'both-changed-different'
      [$s, $t] if $s == $last and $t == $last => 'up-to-date'
    }
  }
}

def mapping-state-and-metadata [file: record, state: record] {
  let source_hash = file-hash $file.source
  let target_hash = file-hash $file.target
  let last_hash = $state | get -o $file.target

  let file_state = mapping-state $source_hash $target_hash $last_hash

  return {
    target: $file.target,
    status: $file_state,
  }
}

def workable-os [mapping: record] {
  let only_list = $mapping | get -o only | default []
  ($only_list | is-empty) or $OS in $only_list 
}

def valid-mapping [mapping: record] {
  mut errors = []

  if ($mapping | get -o source) == null {
    $errors = $errors | append "source missing"
  } else if (($mapping | describe -d).type == 'string') == null {
    $errors = $errors | append "source is not a string"
  }

  if ($mapping | get -o target) == null {
    $errors = $errors | append "target missing"
  } else {
    let target_type = $mapping.target | describe -d | get type
    if $target_type not-in ['string', 'record'] {
      $errors = $errors | append "target should either be a record or a type"
    }
  }

  if ($errors | is-not-empty) {
    print $errors
    return false
  }

  return true
}


export def workable-files [] {
  get-mappings
  | where {|m| valid-mapping $m }
  | where {|m| workable-os $m }
  | each {|m| enumerate-mapping-files $m }
  | flatten
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

def enumerate-mapping-files [mapping: record] {
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

