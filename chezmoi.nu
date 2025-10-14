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
  'shell\wezterm': '.config\wezterm',
  'ides\emacs': '.emacs.d',
  'shell\starship\starship.toml': '.config\starship.toml'
  'windows\clink': 'appdata\local\clink',
  'shell\nushell': 'appdata\roaming\nushell',
  'ides\nvim': 'appdata\local\nvim',
  'ides\lf': 'appdata\local\lf',
  'ides\helix': 'appdata\roaming\helix',
  'windows\autodarkmode\scripts.yaml': 'appdata\roaming\AutoDarkMode\scripts.yaml'
  'ides\zed\settings.json': 'AppData\Roaming\Zed\settings.json'
  'ides\zed\keymap.json': 'AppData\Roaming\Zed\keymap.json'
  'ides\zed\themes\cyan-light.json': 'AppData\Roaming\Zed\themes\cyan-light.json'
  'ides\vscode\keybindings.json': 'AppData\Roaming\Code\keybindings.json'
}


let linux_files = {
  'shell/zsh/.zshrc'                : '.zshrc',
  'shell/zsh/.zshenv'               : '.zshenv',
  'shell/zsh/.zsh_aliases'          : '.zsh_aliases',
  'shell/starship/starship.toml'    : '.config/starship.toml',
  'shell/wezterm'                   : '.config/wezterm',
  'shell/nushell'                   : '.config/nushell',
  'ides/nvim'                       : '.config/nvim',
  'ides/lf'                         : '.config/lf',
  'ides/helix'                      : '.config/helix',
  'ides/zed'                        : '.config/zed',
  'ides/emacs'                      : '.emacs.d',
  'ides/yazi'                       : '.config/yazi' ,
  'ides/jetbrains/.ideavimrc'       : '.ideavimrc',
  'linux/koi/koirc'                 : '.config/koirc',
}
