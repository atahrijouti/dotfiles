@echo off

if not exist "%USERPROFILE%\.config" mkdir "%USERPROFILE%\.config"

set DOTFILES="%USERPROFILE%\playground\git\dotfiles"

mklink /d "%USERPROFILE%\AppData\Local\clink" "%DOTFILES%\windows\clink"
mklink /d "%USERPROFILE%\AppData\Local\nvim" "%DOTFILES%\ides\nvim"
mklink /d "%USERPROFILE%\.config\wezterm" "%DOTFILES%\shell\wezterm"
mklink "%USERPROFILE%\.config\starship.toml" "%DOTFILES%\shell\starship\starship.toml"

mklink "%USERPROFILE%\AppData\Roaming\AutoDarkMode\scripts.yaml" "%DOTFILES%\windows\autodarkmode\scripts.yaml"

mklink /d "%USERPROFILE%\AppData\Local\lf" "%DOTFILES%\ides\lf"


REM Helix
mklink /d "%USERPROFILE%\AppData\Roaming\helix" "%DOTFILES%\ides\helix"

REM MSYS Bash
mklink "%USERPROFILE%\.bash_profile" "%DOTFILES%\windows\msys_shell\.bash_profile"
mklink "%USERPROFILE%\.bash_functions" "%DOTFILES%\windows\msys_shell\.bash_functions"
mklink "%USERPROFILE%\.bash_aliases" "%DOTFILES%\windows\msys_shell\.bash_aliases"

REM VSCode
REM mklink "%USERPROFILE%\AppData\Roaming\Code\keybindings.json" "%DOTFILES%\ides\vscode\keybindings.json"


"C:\Program Files (x86)\clink\\clink.bat" autorun install -- -q