#!/bin/bash

SCRIPT_DIR="$( cd "$( dirname "$BASH_SOURCE[0]" )" && pwd )"

mkdir ~/.config/sway
ln -s $SCRIPT_DIR/sway ~/.config/sway/config

ln -s $SCRIPT_DIR/emacs.el ~/.emacs

mkdir ~/.config/keyd
ln -s $SCRIPT_DIR/keyd/app.conf ~/.config/keyd/app.conf
sudo ln -s $SCRIPT_DIR/keyd/default.conf /etc/keyd/default.conf
