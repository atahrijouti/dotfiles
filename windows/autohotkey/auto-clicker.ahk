#MaxThreadsPerHotkey 3

Toggle := False

F9::{
	Global Toggle := !Toggle
	Loop
	{
		If (!Toggle)
			Break
		Click()
		; Make this number higher for slower clicks, lower for faster.
		Sleep(5)
	}
	Return
}
