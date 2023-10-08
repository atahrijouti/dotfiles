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



^+d::toggleMinimize()


#+r::Reload()