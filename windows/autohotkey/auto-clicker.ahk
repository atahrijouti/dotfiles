#MaxThreadsPerHotkey 3

^z::
{ 
	Toggle := !Toggle
	Loop
	{
		If (!Toggle)
			Break
		Click()
		; Make this number higher for slower clicks, lower for faster.
		Sleep(83) 
	}
	Return
} 
