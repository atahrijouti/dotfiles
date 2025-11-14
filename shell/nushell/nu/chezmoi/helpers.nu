const DOTFILES_ROOT = '~/source/dotfiles'
const STATE_FILE = $"($nu.cache-dir)/chezmoi-state.nuon" | path expand
const MAPPINGS_FILE = path self ./mappings.nuon
const OS = $nu.os-info.name

export def get-workables [filters: list<path> = []] {
  let last_state = (load-state)
  get-mappings
  | where {|m| valid-mapping $m }
  | where {|m| workable-os $m }
  | where {|m| mapping-target-path-filter $m $filters}
  | where {|m| mapping-matches-file-system $m}
  | each {|m| enumerate-mapping-files $m $last_state $filters}
  | flatten
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

def enumerate-mapping-files [mapping: record, last_state: record, filters: list<path>] {
  let mapping_type = resolve-mapping-type $mapping
  let mapping_source = resolve-source $mapping
  let mapping_target = resolve-target $mapping
  
  let target = $mapping_target | path expand -n
  let source = $"($DOTFILES_ROOT)/($mapping_source)"

  let source_type = $source | path type
  let target_type = $target | path type

  match $mapping_type {
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

      let all_relative_paths =  $source_files | append $target_files | uniq | where {|file|
        target-dir-files-filter $file $target $filters
      }

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

export def display-diff [old: path, new: path, status: string, target: path] {
  decorated-print $"\((ansi blue)($status)(ansi reset)) (ansi cyan)($target)(ansi reset)"
  difft $old $new
}

export def decorated-print [text: string] {
  print (([$text] | table -i false -t default) | into string)
}
