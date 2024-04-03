#!/bin/sh

if [ -r /proc/version ] && grep -q microsoft /proc/version; then
	alias xdg-open='explorer.exe'
	alias n='notepad.exe'
	PATH="$PATH:/mnt/d/bin:/mnt/c/Program Files (x86)/Arduino"
fi

mkdir -p ~/.local/share/vim/shada/
mkdir -p ~/.local/share/vim/swap/
mkdir -p ~/.local/share/vim/undo/

if [ -r "$HOME/.cargo/env" ]; then
    . "$HOME/.cargo/env"
fi

export WINEDEBUG=-all
export GOPATH="$HOME/.cargo"
