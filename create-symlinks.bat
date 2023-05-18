@echo off

if not exist "%USERPROFILE%\.config" mkdir "%USERPROFILE%\.config"

set DOTFILES="%USERPROFILE%\playground\git\dotfiles"

mklink /d "%USERPROFILE%\AppData\Local\clink" "%DOTFILES%\windows\clink"
mklink /d "%USERPROFILE%\AppData\Local\nvim" "%DOTFILES%\ides\nvim"
mklink /d "%USERPROFILE%\.config\wezterm" "%DOTFILES%\shell\wezterm"
mklink "%USERPROFILE%\.config\starship.toml" "%DOTFILES%\shell\starship\starship.toml"

REM mklink "%USERPROFILE%\AppData\Roaming\Code\keybindings.json" "%DOTFILES%\ides\vscode\keybindings.json"


"C:\Program Files (x86)\clink\\clink.bat" autorun install -- -q