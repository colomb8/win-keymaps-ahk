#SingleInstance Force

SetTimer(DoubleScrollLock, 60000)

DoubleScrollLock() {
    Send "{ScrollLock}"
    Sleep 50
    Send "{ScrollLock}"
}
