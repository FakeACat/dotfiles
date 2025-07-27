del %AppData%\.emacs
mklink %AppData%\.emacs %userprofile%\.dotfiles\.emacs

del %AppData%\.emacs.d\.mc-lists.el
mklink %AppData%\.emacs.d\.mc-lists.el %userprofile%\.dotfiles\.mc-lists.el

del "%userprofile%\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup\normal.ahk"
mklink "%userprofile%\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup\normal.ahk" %userprofile%\.dotfiles\autohotkey\normal.ahk
