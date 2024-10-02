setx LANG en_US.UTF-8
setx HOME "%USERPROFILE%"
setx DOTFILES "%USERPROFILE%\source\dotfiles"

setx PATH "%PATH%;%DOTFILES%\shell\bin"

setx MSYS winsymlinks:nativestrict
setx MSYS2_PATH_TYPE inherit

@REM helps MSYS2 set $HOME to the windows user directory
setx HELIX_RUNTIME %USERPROFILE%\programs\helix\runtime


@REM auto install and uninstall packages

@REM install Windows Updates
@REM install winaero + Disable all unwanted things
@REM install winget

@REM Uninstall unwanted apps
@REM Cortana
winget uninstall Microsoft.549981C3F5F10_8wekyb3d8bbwe

@REM unlikely to work
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

winget install -e --id chrisant996.Clink -i
winget install -e --id Git.Git -i

winget install -e --id Notepad2mod.Notepad2mod
winget install -e --id 7zip.7zip
winget install -e --id AutoHotkey.AutoHotkey


@REM install JetBrains Mono Nerd font from https://www.nerdfonts.com/font-downloads
winget install -e --id wez.wezterm
winget install -e --id VideoLAN.VLC
winget install -e --id Neovim.Neovim

@REM Install Visual C++ 2015 for neovim
winget install -e --id Microsoft.VCRedist.2015+.x64
winget install -e --id GitHub.cli

winget install -e --id MSYS2.MSYS2 -i
winget install -e --id OlegDanilov.RapidEnvironmentEditor
@REM Add Msys bin folder(s) to the path for the entire system

winget install -e --id Starship.Starship

winget install -e --id Microsoft.VisualStudioCode

winget install -e --id Ditto.Ditto

winget install -e --id Armin2208.WindowsAutoNightMode

winget install -e --id JetBrains.Toolbox

@REM winget install -e --id Love2d.Love2d

@REM pacman -S mingw-w64-ucrt-x86_64-ripgrep

winget install -e --id CoreyButler.NVMforWindows

winget install -e --id Telegram.TelegramDesktop
winget install -e --id KeePassXCTeam.KeePassXC
winget install -e --id Valve.Steam
winget install -e --id Spotify.Spotify
winget install -e --id WhatsApp.WhatsApp
winget install -e --id Discord.Discord
winget install -e --id VideoLAN.VLC
winget install -e --id ShareX.ShareX
winget install -e --id Mp3tag.Mp3tag
winget install -e --id EpicGames.EpicGamesLauncher
winget install -e --id XBMCFoundation.Kodi
winget install -e --id RandomEngy.VidCoder
winget install -e --id TGRMNSoftware.BulkRenameUtility
winget install -e --id OBSProject.OBSStudio
winget install -e --id SumatraPDF.SumatraPDF
winget install -e --id Microsoft.VisualStudio.2022.BuildTools
winget install -e --id Rustlang.Rustup
winget install -e --id XnSoft.XnConvert
winget install -e --id SyncTrayzor.SyncTrayzor
winget install -e --id GitHub.cli
winget install -e --id=jurplel.qView
winget install -e --id Brave.Brave
winget install -e --id=Google.Chrome
winget install -e --id JesseDuffield.lazygit
winget install -e --id gokcehan.lf
winget install -e --id LGUG2Z.whkd
winget install -e --id LGUG2Z.komorebi
winget install -e --id GoLang.Go
winget install -e --id WinSCP.WinSCP
winget install -e --id OpenRA.OpenRA
winget install -e --id WireGuard.WireGuard
winget install -e --id NickeManarin.ScreenToGif
winget install -e --id Microsoft.PowerToys
winget install -e --id Logseq.Logseq
