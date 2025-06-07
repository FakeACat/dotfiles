#
# ~/.bash_profile
#

[[ -f ~/.bashrc ]] && . ~/.bashrc

export _JAVA_AWT_WM_NONREPARENTING=1 # fixes intellij
export __GL_THREADED_OPTIMIZATIONS=0 # fixes minecraft
export EDITOR=kak

export PATH=$PATH\
:~/.dotfiles/scripts

[ "$(tty)" = "/dev/tty1" ] && exec sway --unsupported-gpu
