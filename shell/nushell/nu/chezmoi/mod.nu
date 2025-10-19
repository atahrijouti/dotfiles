#!/usr/bin/env nu

# Manage dotfiles à la chezmoi, with extra features to handle multiple OS setups
# 
# chezmoi est chez toi
export def main [] {
}

export def "apply" [] {
  let mappings = get-mappings
  let os = $nu.os-info.name
  let dotfiles_root = $nu.home-path | path join source dotfiles

  for m in $mappings {
   # --- Check if should skip based on 'only' field ---
    let only_list = $m | get -o only | default []
    let skip = ($only_list | is-not-empty) and not ($only_list | any {|x| $x == $os})
    if $skip { continue }

    # --- Resolve target ---
    let target_raw = if (($m.target | describe -d | get type) == 'record') {
      $m.target | get -o $os
    } else {
      $m.target
    }

    if $target_raw == null { continue }

    let target = ($target_raw | path expand -n)
    let source_raw = ($dotfiles_root | path join $m.source | path expand -n)
    let is_dir = ($source_raw | path type) == 'dir' 

    let source = if $is_dir { $source_raw | path join '*'  } else { $source_raw }
    let target_dir = if $is_dir { $target  } else { $target | path dirname | path expand -n }
    
    # Create target directory only once
    if not ($target_dir | path exists) {
      # mkdir $target_dir
      print $"✓ mkdir ($target_dir)"
    }

    # --- Simple copy ---
    print $"cp -r ($source) ($target)"
  }
}


export def "pull" [] {
  let mappings = get-mappings
  let os = $nu.os-info.name
  let dotfiles_root = $nu.home-path | path join source dotfiles

  for m in $mappings {
    # --- Check if should skip based on 'only' field ---
    let only_list = $m | get -o only | default []
    let skip = ($only_list | is-not-empty) and not ($only_list | any {|x| $x == $os})
    if $skip { continue }

    # --- Resolve target ---
    let target_raw = if (($m.target | describe -d | get type) == 'record') {
      $m.target | get -o $os
    } else {
      $m.target
    }

    if $target_raw == null { continue }

    let target = $target_raw | path expand -n
    let source = $dotfiles_root | path join $m.source

    
    # Check if target exists
    if not ($target | path exists) {
      print $"⚠ Skipped ($m.source) - target not found: ($target)"
      continue
    }

    let all_targets = if ($target | path expand | path type) == file { # TODO Remove extra expand
      [ $target ]
    } else if ($target | path expand | path type) == dir { # TODO Remove extra expand
      # the extra __never_match__/** is because glob won't allow me to pass in just one pattern that doesn't use `foldername/**`
      let ignore_patterns = $m | get -o ignore | default [] | append '__never_match__/**'
      glob $"($target_raw)/**/*" --exclude $ignore_patterns 
    } else {
      []
    }

    print $all_targets

    # # Get ignore patterns and glob files


    # # Only keep files, not directories
    # let target_files = $all_items | where {|item| ($item | path type) == 'file'}

    # if ($target_files | is-empty) {
    #   print $"⚠ No files to pull from ($target)"
    #   continue
    # }

    # # Copy each file back to source
    # for file in $target_files {
    #     let relative_path = $file | path relative-to $target
    #     let source_path = $source | path join $relative_path

    #     if not ($target | path exists) {
    #         # mkdir ($source_path | path dirname)
    #         print $"✓ mkdir ($source_path | path dirname)"
    #     }
    #     cp $file $source_path
    #     print $"✓ Pulled ($relative_path)"
    # }
    }
}

def get-mappings [] {
  const mappings_file = path self ./mappings.nuon
  $mappings_file | open
}
