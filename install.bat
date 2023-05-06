@echo off

mklink /d "%USERPROFILE%\AppData\Local\clink" "%USERPROFILE%\playground\git\dotfiles\windows\clink"
mklink /d "%USERPROFILE%\AppData\Local\nvim" "%USERPROFILE%\playground\git\dotfiles\ides\nvim"
mklink /d "%USERPROFILE%\.config\wezterm" "%USERPROFILE%\playground\git\dotfiles\shell\wezterm"
mklink "%USERPROFILE%\.config\starship.toml" "%USERPROFILE%\playground\git\dotfiles\shell\starship\starship.toml"