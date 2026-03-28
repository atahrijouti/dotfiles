#!k::{
	if WinActive("ahk_exe wezterm-gui.exe") || WinActive("ahk_exe Zed.exe") {
		SendInput "^!k"
	} else {
		SendInput "#!k"
	}
}
