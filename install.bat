@echo off

if not exist "%USERPROFILE%\.config" mkdir "%USERPROFILE%\.config"

mklink /d "%USERPROFILE%\AppData\Local\clink" "%USERPROFILE%\playground\git\dotfiles\windows\clink"
mklink /d "%USERPROFILE%\AppData\Local\nvim" "%USERPROFILE%\playground\git\dotfiles\ides\nvim"
mklink /d "%USERPROFILE%\.config\wezterm" "%USERPROFILE%\playground\git\dotfiles\shell\wezterm"
mklink "%USERPROFILE%\.config\starship.toml" "%USERPROFILE%\playground\git\dotfiles\shell\starship\starship.toml"

"C:\Program Files (x86)\clink\\clink.bat" autorun install -- -q