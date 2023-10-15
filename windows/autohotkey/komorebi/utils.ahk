#Requires AutoHotkey v2.0

isMinimized := false

toggleMinimize() {
  Global isMinimized
  if(isMinimized = true) {
    WinMinimizeAllUndo()
    isMinimized := false
  } else {
    WinMinimizeAll()
    isMinimized := true
  }
}

disableLockWorkstation() {
  RegWrite(1, "REG_DWORD", "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Policies\System", "DisableLockWorkstation")
}

enableLockWorkstation() {
  RegWrite(0, "REG_DWORD", "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Policies\System", "DisableLockWorkstation")
}

lockWorkStation() {
  enableLockWorkstation()
  DllCall("LockWorkStation")
  sleep(1000)
  disableLockWorkstation()
}