#!/usr/bin/env nu
 
let os = sys host | get name
let is_windows = $os == Windows

if $is_windows {
  $env.HOME = $env.USERPROFILE
}

let home_config = $env.HOME | path join .config

# make sure folders we're symlinking into exist
mkdir $home_config


# bootstrap software that needs it
if $is_windows {
  let clink_path = 'C:\Program Files (x86)\clink\clink.bat'
  if (^$clink_path autorun show | grep autorun | str length) == 0 {
    print "enable clink autorun"
    ^$clink_path autorun install -- -q
  }
}

# started with folders
let windows_files = {
  'ides\emacs': '.emacs.d',
  'ides\nvim': 'appdata\local\nvim',
  'ides\lf': 'appdata\local\lf',
  'ides\helix': 'appdata\roaming\helix',
  'ides\zed\settings.json': 'AppData\Roaming\Zed\settings.json'
  'ides\zed\keymap.json': 'AppData\Roaming\Zed\keymap.json'
  'ides\zed\themes\cyan-light.json': 'AppData\Roaming\Zed\themes\cyan-light.json'
  'ides\vscode\keybindings.json': 'AppData\Roaming\Code\keybindings.json'
  'shell\wezterm': '.config\wezterm',
  'shell\starship\starship.toml': '.config\starship.toml'
  # 'shell\nushell': 'appdata\roaming\nushell',
  'windows\clink': 'appdata\local\clink',
  'windows\autodarkmode\scripts.yaml': 'appdata\roaming\AutoDarkMode\scripts.yaml'
}


let linux_files = {
  'ides/nvim'                       : '.config/nvim',
  'ides/lf'                         : '.config/lf',
  'ides/helix'                      : '.config/helix',
  'ides/zed'                        : '.config/zed',
  'ides/emacs'                      : '.emacs.d',
  'ides/yazi'                       : '.config/yazi' ,
  'ides/jetbrains/.ideavimrc'       : '.ideavimrc',
  'shell/zsh/.zshrc'                : '.zshrc',
  'shell/zsh/.zshenv'               : '.zshenv',
  'shell/zsh/.zsh_aliases'          : '.zsh_aliases',
  # 'shell/starship/starship.toml'    : '.config/starship.toml',
  # 'shell/wezterm'                   : '.config/wezterm',
  # 'shell/nushell'                   : '.config/nushell',
  # 'linux/koi/koirc'                 : '.config/koirc',
}

let mappings = [
  {
    source: 'shell/nushell',
    target: {
      Windows: '~/appdata\roaming\nushell',
      Linux: '~/.config/nushell',
      Darwin: '~/Library/Application\ Support'
    }
  },
  {
    source: 'linux/koi/koirc',
    target: {
      Linux: '~/.config/koirc',
    }
  },
  { source: 'shell/wezterm', target: '~/.config/wezterm' },
  { source :'shell/starship/starship.toml', target: '~/.config/starship.toml' },
  { source :'shell/zsh/*', target: '~', only: [Linux, Darwin]},
]

let os = (sys host | get name | str capitalize)
let dotfiles_root = $nu.home-path | path join source dotfiles

for m in $mappings {

    let skip = not ($m | get only? | default [] | any {|x| $x == $os} ) and ($m | get only? | is-not-empty)
    if $skip { continue }

    # --- Resolve target ---
    let target_raw = if (($m.target | describe -d | get type) == 'record') {
        $m.target | get -o $os
    } else {
        $m.target
    }

    if $target_raw == null { continue }

    let target_dir = ($target_raw | path expand)

    # --- Resolve source ---
    let source_path = ($dotfiles_root | path join $m.source)
    let sources = if ($source_path | str contains '*') {
        glob $source_path
    } else {
        [$source_path]
    }

    # --- Copy logic ---
    for src in $sources {
        let filename = ($src | path basename)
        let dst = (
            if ($target_dir | path type) == 'dir' {
                $target_dir | path join $filename
            } else {
                $target_dir
            }
        )

        print $"→ ($src) → ($dst)"
        # mkdir ($dst | path dirname)
        # cp -r $src $dst
    }
}
