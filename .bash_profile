#
# ~/.bash_profile
#

[[ -f ~/.bashrc ]] && . ~/.bashrc

# fixes intellij
export _JAVA_AWT_WM_NONREPARENTING=1

if [[ $(hostname) = "ilovelinux" ]] # home desktop
then
    # nvidia issues :3

    # fixes minecraft
    export __GL_THREADED_OPTIMIZATIONS=0

    # fixes a few xwayland games
    export WLR_RENDER_NO_EXPLICIT_SYNC=1
elif [[ $(hostname) = "i-love-linux" ]] # laptop
then
    # fixes a few xwayland games
    export WLR_RENDER_NO_EXPLICIT_SYNC=1
fi

# the only good text editor
export EDITOR=emacs

export PATH=$PATH\
:~/.dotfiles/scripts\
:~/bin

DOTNET_LOCATION=~/thirdparty/dotnet
if [ -d $DOTNET_LOCATION ]
then
    export DOTNET_ROOT=$DOTNET_LOCATION
    export PATH=$PATH:$DOTNET_ROOT:$DOTNET_ROOT
fi

[ "$(tty)" = "/dev/tty1" ] && exec sway --unsupported-gpu
