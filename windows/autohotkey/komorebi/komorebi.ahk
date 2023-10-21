#Requires AutoHotkey v2.0

#SingleInstance Force

Persistent

#Include utils.ahk
#Include lib.ahk
#Include keymap.ahk

disableLockWorkstation()

OnExit ExitFunc

ExitFunc(*)
{
    enableLockWorkstation()   
}

#+C::Reload()