const DOTFILES_ROOT = '~/source/dotfiles'
const STATE_FILE = $"($nu.cache-dir)/chezmoi-state.nuon" | path expand
const MAPPINGS_FILE = path self ./mappings.nuon
const OS = $nu.os-info.name

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

export def mapping-status [source: oneof<string, nothing>, target: oneof<string, nothing>, last: oneof<string, nothing>] {
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

export def workable-file-mappings [filter: list<path> = []] {
  let last_state = (load-state)
  get-mappings
  | where {|m| valid-mapping $m }
  | where {|m| workable-os $m }
  | where {|m| path-filter $m $filter}
  | each {|m| enumerate-mapping-files $m $last_state}
  | flatten
}

def path-filter [mapping: record, filters: list<path>] {
  if ($filters | is-empty) {
    return true
  }

  let target = resolve-target $mapping 

  $filters | any {|filter|
    paths-overlap $target $filter
  }
}

def paths-overlap [path: path, other:path] {
  if $path == $other {
    return true
  }
  try {
    $path | path relative-to $other
    return true
  }
  try {
    $other | path relative-to $path
    return true
  }
  return false
}

def file-hash [path: string] {
  if not ($path | path exists) { return null }
  open --raw $path | hash sha256
}

def get-mappings [] {
  $MAPPINGS_FILE | open
}
 
def resolve-target [mapping: record] {
  if ($mapping.target | describe -d | get type) == 'record' {
    $mapping.target | get -o $nu.os-info.name
  } else {
    $mapping.target
  } 
}

export def load-state [] {
  if not ($STATE_FILE | path exists) { return {} }
  open $STATE_FILE
}
export def update-state-for-target [state: record, target: path, hash: string] {
  $state | upsert $target $hash
}

export def remove-state-for-target [state: record, target: path] {
  $state | reject $target
}

export def save-state [state: record] {
  if not $env.DRY_RUN? {
    let state_dir = $STATE_FILE | path dirname
    if not ($state_dir | path exists) { mkdir $state_dir }
    $state | save -f $STATE_FILE
  }
}

export def list-folder-files [root: string, includes: list, excludes: list] {
  if not ($root | path exists)  or ($root | path type) == symlink {
    return []
  }
  
  if ($root | path type) == file {
    return [$root]
  }
  
  let files = if ($includes | is-not-empty) {
    $includes | each {|pattern|
      glob $"($root)/($pattern)" --no-dir
    } | flatten
  } else {
    let exclude_patterns = $excludes | append '__never_match__/**'
    glob $"($root)/**/*" --no-dir --exclude $exclude_patterns
  }

  $files | path relative-to $root
}

def enumerate-mapping-files [mapping: record, last_state: record] {
  let mapping_source = $mapping.source
  let mapping_target = resolve-target $mapping
  
  let target = $mapping_target | path expand -n
  let source = $"($DOTFILES_ROOT)/($mapping_source)"

  let source_type = $source | path type
  let target_type = $target | path type

  if $target_type == 'symlink' {
    print $" Unexpected symlink at target ($target)"
    return []
  }

  match $source_type {
    'file' => {
      let expanded_source = $source | path expand -n
      let source_hash = file-hash $expanded_source
      let target_hash = file-hash $target
      let last_hash = $last_state | get -o $target
      let status = mapping-status $source_hash $target_hash $last_hash
      [{
        source: $expanded_source,
        source_hash: $source_hash,
        target: $target,
        target_hash: $target_hash,
        last_hash: $last_hash,
        status: $status
      }]
    },
    'dir' => {
      let excludes = $mapping | get -o excludes | default []
      let includes = $mapping | get -o includes | default []

      let source_files = list-folder-files $source $includes $excludes
      let target_files = list-folder-files $mapping_target $includes $excludes

      let all_relative_paths =  $source_files | append $target_files | uniq

      (
        $all_relative_paths | each {|$relative|
          let source_path = $source | path join $relative | path expand -n
          let target_path = $target | path join $relative | path expand -n

          let source_hash = file-hash $source_path
          let target_hash = file-hash $target_path
          let last_hash = $last_state | get -o $target_path 
          let status = mapping-status $source_hash $target_hash $last_hash

          {
            source: $source_path,
            source_hash: $source_hash,
            target: $target_path,
            target_hash: $target_hash,
            last_hash: $last_hash,
            status: $status
          }
        }
      )
    }
  }
}

export def copy-file [from: string, to: string] {
  let to_dir = $to | path dirname
  if not ($to_dir | path exists) {
    if not $env.DRY_RUN? {
      mkdir $to_dir
    }
    print $" mkdir ($to_dir)"
  }

  if not $env.DRY_RUN? {
    cp $from $to
  }
  print $" cp ($from) ($to)"
}
