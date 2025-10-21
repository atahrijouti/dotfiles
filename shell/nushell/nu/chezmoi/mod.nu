# Manage dotfiles à la chezmoi, with extra features to handle multiple OS setups
# 
# chezmoi est chez toi
export def main [] {
}

export def "apply" [] {
  let mappings = get-mappings
  let dotfiles_root = $nu.home-path | path join source dotfiles

  for m in $mappings {
    if (should-skip $m) { continue }

    let target_relative = resolve-target $m
    if $target_relative == null { continue }

    let target = $target_relative | path expand -n
    let source_raw = ($dotfiles_root | path join $m.source | path expand -n)
    let is_dir = ($source_raw | path type) == 'dir' 

    let source = if $is_dir { $source_raw | path join '*'  } else { $source_raw }
    let target_dir = if $is_dir { $target  } else { $target | path dirname | path expand -n }
    
    # Create target directory only once
    if not ($target_dir | path exists) {
      mkdir $target_dir
      print $"✓ mkdir ($target_dir)"
    }

    # --- Simple copy ---
    print $"cp -r ($source) ($target)"
    cp -r ($source | into glob) $target
  }
}

export def "pull" [] {
  let mappings = get-mappings
  let dotfiles_root = $nu.home-path | path join source dotfiles

  for m in $mappings {
    if (should-skip $m) { continue }

    let target_relative = resolve-target $m
    if $target_relative == null { continue }

    let target = $target_relative | path expand -n
    let source = $dotfiles_root | path join $m.source 
    
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
      cp $target_file $source_path
    }
  }
}

def get-mappings [] {
  const mappings_file = path self ./mappings.nuon
  $mappings_file | open
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
