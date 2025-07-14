#!/bin/bash

set -e

install() {
    origin=~/.dotfiles/$1
    dest=$2
    if [[ ! $3 = "sudo" && ! $3 = "" ]]
    then
        echo "[ERROR] install expects sudo or nothing as third argument, got \"$3\""
        exit 1
    fi
    maybe_sudo=$3

    mkdir -p $(dirname $dest)

    if [ -L $dest ]
    then
        current_symlink_target=$(readlink -f $dest)
        if [ $current_symlink_target = "$origin" ]
        then
            echo "[OK] $dest is already installed"
            return
        fi
        echo "[WARN] $dest is already a symlink but points to $current_symlink_target instead of $origin"
        echo "removing $dest..."
        $maybe_sudo rm $dest
    fi

    if [ -e $dest ]
    then
        echo "[ERROR] $dest already exists and is not a symlink"
        exit 1
    fi

    $maybe_sudo ln -s $origin $dest
    echo "[SUCCESS] installed $dest"
}

install .bashrc ~/.bashrc
install .bash_profile ~/.bash_profile

install keyd/default.conf /etc/keyd/default.conf sudo

install foot.ini ~/.config/foot/foot.ini

install .emacs ~/.emacs
install .mc-lists.el ~/.emacs.d/.mc-lists.el

install .tmux.conf ~/.tmux.conf

install sway/config ~/.config/sway/config

install gtk-3.0/settings.ini ~/.config/gtk-3.0/settings.ini

install rofi/config.rasi ~/.config/rofi/config.rasi
