use ./constants.nu *

export def get-workables [filters: list<path> = [], verbose: bool = false] {
  let last_state = (load-state)
  get-mappings
  | where (valid-mapping $it)
  | where (workable-os $it)
  | where (mapping-target-path-filter $it $filters)
  | where (mapping-matches-file-system $it)
  | each {|m| get-mapping-files $m $last_state $filters } | flatten
  | each {|m| make-workable $m $last_state }
  | where $verbose or $it.status != 'up-to-date'
}

def valid-mapping [mapping: record] {
  mut errors = []

  let source_is_dir = ($mapping | get -o dir) != null
  let source_is_file = ($mapping | get -o file) != null

  if not ($source_is_dir or $source_is_file) {
    $errors = $errors | append "file/dir attribute missing"
  } else if ($source_is_dir and $source_is_file) {
    $errors = $errors | append "both file & dir attributes used"
  } else {
    if ($source_is_file and ($mapping.file | describe -d).type != string) {
      $errors = $errors | append "file is not a string"
    } else if ($source_is_dir and ($mapping.dir | describe -d).type != string) {
      $errors = $errors | append "dir is not a string"
    }
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

def workable-os [mapping: record] {
  let only_list = $mapping | get -o only | default []
  ($only_list | is-empty) or $OS in $only_list 
}

def mapping-target-path-filter [mapping: record, filters: list<path>] {
  if ($filters | is-empty) {
    return true
  }

  let target = resolve-target $mapping 

  $filters | any {|filter|
    paths-overlap $target $filter
  }
}

def mapping-matches-file-system [mapping: record] {
  let mapping_type = resolve-mapping-type $mapping
  let mapping_source = resolve-source $mapping
  let mapping_target = resolve-target $mapping

  let target = $mapping_target | path expand -n
  let source = $"($DOTFILES_ROOT)/($mapping_source)" | path expand -n

  let source_type = $source | path type
  let target_type = $target | path type

  if $target_type == 'symlink' {
    print $" SKIP: Unexpected symlink at target ($target)"
    return false
  }

  if $source_type == 'symlink' {
    print $" SKIP: Unexpected symlink at source ($source)"
    return false
  }

  if ($mapping_type == 'file' and $target_type == 'dir') {
    print $" SKIP: Mapping expects file but target is directory ($target)"
    return false
  }

  if ($mapping_type == 'dir' and $target_type == 'file') {
    print $" SKIP: Mapping expects directory but target is file ($target)"
    return false
  }

  if ($mapping_type == 'file' and $source_type == 'dir') {
    print $" SKIP: Mapping expects file but source is directory ($source | path expand -n)"
    return false
  }

  if ($mapping_type == 'dir' and $source_type == 'file') {
    print $" SKIP: Mapping expects directory but source is file ($source | path expand -n)"
    return false
  }

  return true
}

def make-workable [mapping: record, last_state: record] {
  let source_hash = file-hash $mapping.source
  let target_hash = file-hash $mapping.target
  let last_hash = $last_state | get -o $mapping.target
  let status = workable-status $source_hash $target_hash $last_hash
  let action = workable-action $status

  return {
    source: $mapping.source,
    source_hash: $source_hash,
    target: $mapping.target,
    target_hash: $target_hash,
    last_hash: $last_hash,
    status: $status,
    action: $action
  }
}

def get-mapping-files [mapping: record, last_state:record, filters: list<path>] {
  let mapping_type = resolve-mapping-type $mapping
  let mapping_source = resolve-source $mapping
  let mapping_target = resolve-target $mapping
  let target = $mapping_target | path expand -n
  let source = $"($DOTFILES_ROOT)/($mapping_source)"

  match $mapping_type {
    'file' => {
      return {
        source: ($source | path expand -n),
        target: $target,
      }
    },
    'dir' => {
      let excludes = $mapping | get -o excludes | default []
      let includes = $mapping | get -o includes | default []

      let source_files = list-folder-files $source $includes $excludes
      let target_files = list-folder-files $mapping_target $includes $excludes
      let tracked_target_files = tracked-dir-mapping-files $mapping $last_state

      let all_relative_paths =  $source_files | append $target_files | append $tracked_target_files | uniq | where {|file|
        target-dir-files-filter $file $target $filters
      }

      return (
        $all_relative_paths | each {|$relative|
          {
            source: ($source | path join $relative | path expand -n),
            target: ($target | path join $relative | path expand -n),
          }
        }
      )
    }
  }
}

export def do-magic [filters: list<path> = []] {
  print "🎉"
}

def path-matches-glob-in-dir [path: path, pattern: string, base: path] {
  if ($pattern | str ends-with '/**') {
    let dir = $pattern | str replace -r '/\*\*$' ''
    let dir_path  = $base | path join $dir
    path-in-other $path $dir_path
  } else if ($pattern | str ends-with '*') {
    let prefix = ($pattern | str replace -r '\*$' '')
    let prefix_path = $base | path join $prefix | path expand -n
    $path | str starts-with $prefix_path
  } else {
    let full_pattern_path = ($base | path join $pattern | path expand)
    $path == $full_pattern_path or (path-in-other $path $full_pattern_path)
  }
}

def mapping-filters-validate-path [path: path, mapping: record] {
  let includes = $mapping | get -o includes | default []
  let excludes = $mapping | get -o excludes | default []
  let mapping_target = resolve-target $mapping

  let patterns = if ($includes | is-not-empty) {
    $includes
  } else {
    $excludes
  }

  let pattern_matches_path = $patterns | any {|pattern|
    path-matches-glob-in-dir $path $pattern $mapping_target
  }

  if ($includes | is-not-empty) {
    $pattern_matches_path
  } else {
    not $pattern_matches_path
  }
}

export def tracked-dir-mapping-files [mapping: record, state: record] {
  let mapping_target = resolve-target $mapping
  $state
  | items {|tracked_target, hash| $tracked_target}
  | where {|tracked_target| path-in-other $tracked_target $mapping_target}
  | where (mapping-filters-validate-path $it $mapping)
  | path relative-to $mapping_target
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

export def workable-status [source: oneof<string, nothing>, target: oneof<string, nothing>, last: oneof<string, nothing>] {
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

def workable-action [status: string] {
  match $status {
    'untracked-both-missing' => 'Inform',
    'untracked-source-missing' => 'Pull (New)',
    'untracked-target-missing' => 'Apply (New)',
    'untracked-identical' => 'Update State',
    'untracked-different' => 'Resolve Conflict (Untracked)',
    'both-deleted' => 'Update State',
    'source-deleted' => 'Delete Target',
    'source-deleted-target-changed' => 'Resolve Conflict (Deletion)',
    'target-deleted' => 'Delete Source',
    'target-deleted-source-changed' => 'Resolve Conflict (Deletion)',
    'source-changed' => 'Apply',
    'target-changed' => 'Pull',
    'both-changed-identical' => 'Update State',
    'both-changed-different' => 'Resolve Conflict',
    'up-to-date' => 'Inform',
  }
}

def target-dir-files-filter [file: path, target: path, filters: list<path>] {
  if ($filters | is-empty) {
    return true
  }
  let target_path = $target | path join $file | path expand -n
  $filters | any {|filter|
    paths-overlap $target_path  $filter
  }
}

def paths-overlap [path: path, other:path] {
  if $path == $other {
    return true
  }

  if (path-in-other $path $other) {
    return true
  }

  if (path-in-other $other $path) {
    return true
  }

  return false
}

def path-in-other [path: path, other: path] {
  try {
    $path | path relative-to $other
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

def resolve-source [mapping: record] {
  match (resolve-mapping-type $mapping) {
    'file' => $mapping.file,
    'dir' => $mapping.dir
  }
}

def resolve-mapping-type [mapping: record] {
  if ($mapping | get -o file) != null {
    'file'
  } else {
    'dir'
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

export def copy-file [from: string, to: string] {
  let to_dir = $to | path dirname
  if not ($to_dir | path exists) {
    if not $env.DRY_RUN? {
      mkdir $to_dir
    }
    print $"(ansi purple)(ansi reset) mkdir ($to_dir)"
  }

  if not $env.DRY_RUN? {
    cp $from $to
  }
  print $"(ansi cyan)(ansi reset) cp ($from) ($to)"
}

export def display-diff [old: path, new: path, status: string, target: path] {
  print-diff-header $status $target
  difft $old $new
}

export def print-diff-header [status: string, target: path] {
  decorated-print $"\((ansi blue)($status)(ansi reset)) (ansi cyan)($target)(ansi reset)"
}

export def decorated-print [text: any] {
  print (([$text] | flatten | table -i false -t default) | into string)
}
