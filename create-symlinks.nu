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
let items = {
  'windows\clink': 'appdata\local\clink',
  'shell\nushell': 'appdata\roaming\nushell',
  'ides\nvim': 'appdata\local\nvim',
  'shell\wezterm': '.config\wezterm',
  'ides\lf': 'appdata\local\lf',
  'ides\helix': 'appdata\roaming\helix',
  'ides\emacs': '.emacs.d',
}


# REM Starship
# mklink "%USERPROFILE%\.config\starship.toml" "%DOTFILES%\shell\starship\starship.toml"

# REM AutoDarkMode
# mklink "%APPDATA%\AutoDarkMode\scripts.yaml" "%DOTFILES%\windows\autodarkmode\scripts.yaml"

# REM Zed
# mklink "%USERPROFILE%\AppData\Roaming\Zed\settings.json" "%DOTFILES%\ides\zed\settings.json"
# mklink "%USERPROFILE%\AppData\Roaming\Zed\keymap.json" "%DOTFILES%\ides\zed\keymap.json"
# mklink "%USERPROFILE%\AppData\Roaming\Zed\themes\cyan-light.json" "%DOTFILES%\ides\zed\themes\cyan-light.json"
 
# REM VSCode
# REM mklink "%USERPROFILE%\AppData\Roaming\Code\keybindings.json" "%DOTFILES%\ides\vscode\keybindings.json"

