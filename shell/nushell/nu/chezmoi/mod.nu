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
    let source = ($dotfiles_root | path join $m.source | path expand)

    # Create target directory only once
    if not ($target | path exists) {
      mkdir $target
      print $"✓ mkdir ($target)"
    }

    # --- Simple copy ---
    print $"cp -r '($source)' '($target)'"
  }
}


def get-mappings [] {
  const mappings_file = path self ./mappings.nuon
  $mappings_file | open
}
