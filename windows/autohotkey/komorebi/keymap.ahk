#Requires AutoHotkey v2.0


#+E::lockWorkStation()


; Focus windows
#H::Focus("left")
#J::Focus("down")
#K::Focus("up")
#L::Focus("right")
#[::CycleFocus("previous")
#]::CycleFocus("next")

; Move windows
#+H::Move("left")
#+J::Move("down")
#+K::Move("up")
#+L::Move("right")
#+P::Promote()

; Stack windows
!#H::Stack("left")
!#L::Stack("right")
!#K::Stack("up")
!#J::Stack("down")
!#U::Unstack()
!#[::CycleStack("previous")
!#]::CycleStack("next")

; Resize
^#L::ResizeAxis("horizontal", "increase")
^#H::ResizeAxis("horizontal", "decrease")
^#K::ResizeAxis("vertical", "increase")
^#J::ResizeAxis("vertical", "decrease")

; Manipulate windows
#F::ToggleMonocle()
#+Space::ToggleFloat()

; Window manager options
#+R::Retile()
#+Z::TogglePause()

; Layouts
#+X::FlipLayout("horizontal") 
#+Y::FlipLayout("vertical")

; Workspaces
#1::FocusWorkspace(0)
#2::FocusWorkspace(1)
#3::FocusWorkspace(2)

; Move windows across workspaces
#+1::MoveToWorkspace(0)
#+2::MoveToWorkspace(1)
#+3::MoveToWorkspace(2)




#+S::{
    disableLockWorkstation()
    ; Stop()
    Start()
}

#+Q::{
    enableLockWorkstation()
    Stop()
}