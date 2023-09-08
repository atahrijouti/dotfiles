@echo off

setx HOME "%USERPROFILE%"

if not exist "%USERPROFILE%\.config" mkdir "%USERPROFILE%\.config"
setx DOTFILES "%USERPROFILE%\playground\git\dotfiles"


REM clink
mklink /d "%USERPROFILE%\AppData\Local\clink" "%DOTFILES%\windows\clink"
"C:\Program Files (x86)\clink\\clink.bat" autorun install -- -q

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

REM Helix
mklink /d "%APPDATA%\helix" "%DOTFILES%\ides\helix"

REM MSYS Bash
mklink "%USERPROFILE%\.bash_profile" "%DOTFILES%\windows\msys_shell\.bash_profile"
mklink "%USERPROFILE%\.bash_functions" "%DOTFILES%\windows\msys_shell\.bash_functions"
mklink "%USERPROFILE%\.bash_aliases" "%DOTFILES%\windows\msys_shell\.bash_aliases"

REM Emacs
if not exist "%HOME%\.emacs.d" mkdir "%HOME%\.emacs.d"
mklink "%HOME%\.emacs.d\init.el" "%DOTFILES%\ides\emacs\init.el"
mklink "%HOME%\.emacs.d\early-init.el" "%DOTFILES%\ides\emacs\early-init.el"
mklink /d "%HOME%\.emacs.d\lisp" "%DOTFILES%\ides\emacs\lisp"

REM VSCode
REM mklink "%USERPROFILE%\AppData\Roaming\Code\keybindings.json" "%DOTFILES%\ides\vscode\keybindings.json"
