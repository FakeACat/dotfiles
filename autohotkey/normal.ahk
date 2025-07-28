*CapsLock::Send "{Blind}{Ctrl DownR}"

*CapsLock Up::
{
    Send "{Blind}{Ctrl up}"
    If (A_PriorKey = "CapsLock")
        Send "{Blind}{Esc}"
}