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
      Linux: '~/.config/nvim',
      Windows: '~/AppData/Local/nvim',
      Darwin: '~/.config/nvim'
    },
  },
  {
    source: 'ides/lf/*',
    target: {
      Linux: '~/.config/lf',
      Windows: '~/AppData/Local/lf',
      Darwin: '~/.config/lf'
    },
  },
  {
    source: 'ides/helix/*',
    target: {
      Linux: '~/.config/helix',
      Windows: '~/AppData/Roaming/helix',
      Darwin: '~/.config/helix'
    },
  },
  { source: 'ides/jetbrains/.ideavimrc', target: '~' },
  {
    source: 'ides/zed/*',
    target: {
      Linux: '~/.config/zed',
      Windows: '~/AppData/Roaming/Zed',
      Darwin: '~/.config/zed'
    },
  },
  {
    source: 'linux/koi/koirc',
    target: {
      Linux: '~/.config',
    }
  },
  {
    source: 'shell/nushell',
    target: {
      Windows: '~/AppData/Roaming',
      Linux: '~/.config',
      Darwin: '~/Library/Application Support'
    }
  },
  { source: 'shell/wezterm', target: '~/.config' },
  { source :'shell/starship/starship.toml', target: '~/.config' },
  { source :'shell/zsh/*', target: '~', only: [Linux, Darwin] },
  { source: 'windows/clink', target: '~/AppData/Local', only: [Windows] },
  { source: 'windows/autodarkmode/scripts.yaml', target: '~/AppData/Roaming/AutoDarkMode', only: [Windows] }
]

let os = ($nu.os-info.name | str capitalize)
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

  mkdir $target

  # --- Simple copy ---
  print $"mkdir ($target)"
  print $"cp -r ($source) ($target)"
}
