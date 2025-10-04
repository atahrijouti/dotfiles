@echo off


if not exist "%USERPROFILE%\.config" mkdir "%USERPROFILE%\.config"


REM clink
REM mklink /d "%USERPROFILE%\AppData\Local\clink" "%DOTFILES%\windows\clink"
REM "C:\Program Files (x86)\clink\\clink.bat" autorun install -- -q

REM nushell
mklink /d "%USERPROFILE%\AppData\Roaming\nushell" "%DOTFILES%\shell\nushell"
mklink /d "%USERPROFILE%\AppData\Roaming\vivid" "%DOTFILES%\shell\vivid"

REM vivid
mklink /d 



REM NeoVIM
mklink /d "%USERPROFILE%\AppData\Local\nvim" "%DOTFILES%\ides\nvim"

REM WezTerm
mklink /d "%USERPROFILE%\.config\wezterm" "%DOTFILES%\shell\wezterm"

REM Starship
mklink "%USERPROFILE%\.config\starship.toml" "%DOTFILES%\shell\starship\starship.toml"

REM AutoDarkMode
mklink "%APPDATA%\AutoDarkMode\scripts.yaml" "%DOTFILES%\windows\autodarkmode\scripts.yaml"

REM lf
mklink /d "%USERPROFILE%\AppData\Local\lf" "%DOTFILES%\ides\lf"
mklink "%USERPROFILE%\programs\bin\lfcd.cmd" "%DOTFILES%\windows\lf\lfcd.cmd"

REM Zed
mklink "%USERPROFILE%\AppData\Roaming\Zed\settings.json" "%DOTFILES%\ides\zed\settings.json"
mklink "%USERPROFILE%\AppData\Roaming\Zed\keymap.json" "%DOTFILES%\ides\zed\keymap.json"
mklink "%USERPROFILE%\AppData\Roaming\Zed\themes\cyan-light.json" "%DOTFILES%\ides\zed\themes\cyan-light.json"

REM Helix
mklink /d "%APPDATA%\helix" "%DOTFILES%\ides\helix"

RED ZSH
mklink "%USERPROFILE%\.zshrc" "%DOTFILES%\shell\zsh\.zshrc.windows"
mklink "%USERPROFILE%\.zsh_aliases" "%DOTFILES%\shell\zsh\.zsh_aliases"
mklink "%USERPROFILE%\.starship-msys2-init-zsh" "%DOTFILES%\shell\zsh\.starship-msys2-init-zsh"

REM Emacs
mklink /d "%HOME%\.emacs.d" "%DOTFILES%\ides\emacs"

REM VSCode
REM mklink "%USERPROFILE%\AppData\Roaming\Code\keybindings.json" "%DOTFILES%\ides\vscode\keybindings.json"

