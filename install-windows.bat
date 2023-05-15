REM install Windows Updates
REM install winaero + Disable all unwanted things
REM install winget


REM Uninstall unwanted apps
REM Cortana
winget uninstall Microsoft.549981C3F5F10_8wekyb3d8bbwe

REM unlikely to work
winget uninstall Microsoft.Edge
winget uninstall Microsoft.BingWeather_8wekyb3d8bbwe

winget uninstall Microsoft.GetHelp_8wekyb3d8bbwe
winget uninstall Microsoft.Getstarted_8wekyb3d8bbwe
winget uninstall Microsoft.MSPaint_8wekyb3d8bbwe
winget uninstall Microsoft.Microsoft3DViewer_8wekyb3d8bbwe
winget uninstall Microsoft.MicrosoftOfficeHub_8wekyb3d8bbwe
winget uninstall Microsoft.MicrosoftSolitaireCollection_8wekyb3d8bbwe
winget uninstall Microsoft.MicrosoftStickyNotes_8wekyb3d8bbwe

winget uninstall Microsoft.MixedReality.Portal_8wekyb3d8bbwe
winget uninstall Microsoft.Office.OneNote_8wekyb3d8bbwe
winget uninstall Microsoft.People_8wekyb3d8bbwe
winget uninstall Microsoft.ScreenSketch_8wekyb3d8bbwe
winget uninstall Microsoft.SkypeApp_kzf8qxf38zg5c
winget uninstall Microsoft.StorePurchaseApp_8wekyb3d8bbwe
winget uninstall Microsoft.Wallet_8wekyb3d8bbwe
winget uninstall Microsoft.WindowsFeedbackHub_8wekyb3d8bbwe
winget uninstall Microsoft.WindowsMaps_8wekyb3d8bbwe
winget uninstall Microsoft.ZuneMusic_8wekyb3d8bbwe
winget uninstall Microsoft.ZuneVideo_8wekyb3d8bbwe
winget uninstall Microsoft.OneDrive

REM install Git, Clink manually for their tricky settings during installation
winget install -e --id Notepad2mod.Notepad2mod
winget install -e --id 7zip.7zip

REM install JetBrains Mono Nerd font from https://www.nerdfonts.com/font-downloads
winget install -e --id wez.wezterm
winget install -e --id VideoLAN.VLC
winget install -e --id Neovim.Neovim

REM Install Visual C++ 2015 for neovim
winget install -e --id Microsoft.VCRedist.2015+.x64
winget install -e --id GitHub.cli

winget install -e --id MSYS2.MSYS2
winget install -e --id OlegDanilov.RapidEnvironmentEditor
REM Add Msys bin folder(s) to the path for the entire system

winget install -e --id Starship.Starship

winget install -e --id Microsoft.VisualStudioCode

winget install -e --id Ditto.Ditto

winget install -e --id Armin2208.WindowsAutoNightMode

winget install -e --id JetBrains.Toolbox

REM winget install -e --id Love2d.Love2d

REM pacman -S mingw-w64-ucrt-x86_64-ripgrep

winget install -e --id CoreyButler.NVMforWindows
