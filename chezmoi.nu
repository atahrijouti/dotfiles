#!/usr/bin/env nu
 
# let os = sys host | get name
# let is_windows = $os == Windows

# if $is_windows {
#   $env.HOME = $env.USERPROFILE
# }

# let home_config = $env.HOME | path join .config

# # make sure folders we're symlinking into exist
# mkdir $home_config


# # bootstrap software that needs it
# if $is_windows {
#   let clink_path = 'C:\Program Files (x86)\clink\clink.bat'
#   if (^$clink_path autorun show | grep autorun | str length) == 0 {
#     print "enable clink autorun"
#     ^$clink_path autorun install -- -q
#   }
# }

let mappings = [
  { source: 'ides/emacs/*', target: '~/.emacs.d' },
  {
    source: 'ides/nvim/*',
    target: {
      linux: '~/.config/nvim',
      windows: '~/AppData/Local/nvim',
      macos: '~/.config/nvim'
    },
  },
  {
    source: 'ides/lf/*',
    target: {
      linux: '~/.config/lf',
      windows: '~/AppData/Local/lf',
      macos: '~/.config/lf'
    },
  },
  {
    source: 'ides/helix/*',
    target: {
      linux: '~/.config/helix',
      windows: '~/AppData/Roaming/helix',
      macos: '~/.config/helix'
    },
  },
  { source: 'ides/jetbrains/.ideavimrc', target: '~' },
  {
    source: 'ides/zed/*',
    target: {
      linux: '~/.config/zed',
      windows: '~/AppData/Roaming/Zed',
      macos: '~/.config/zed'
    },
  },
  {
    source: 'linux/koi/koirc',
    target: {
      linux: '~/.config',
    }
  },
  {
    source: 'shell/nushell',
    target: {
      windows: '~/AppData/Roaming',
      linux: '~/.config',
      macos: '~/Library/Application Support'
    }
  },
  { source: 'shell/wezterm', target: '~/.config' },
  { source :'shell/starship/starship.toml', target: '~/.config' },
  { source :'shell/zsh/*', target: '~', only: [linux, macos] },
  { source: 'windows/clink', target: '~/AppData/Local', only: [windows] },
  { source: 'windows/autodarkmode/scripts.yaml', target: '~/AppData/Roaming/AutoDarkMode', only: [windows] }
]

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
