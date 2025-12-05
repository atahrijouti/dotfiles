#!k::{
	if WinActive("ahk_exe wezterm-gui.exe") {
		SendInput "^!k"
	} else {
		SendInput "#!k"
	}
}

