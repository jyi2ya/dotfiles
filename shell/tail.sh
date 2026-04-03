#!/bin/sh

if [ -r /proc/version ] && grep -q microsoft /proc/version; then
	alias xdg-open='explorer.exe'
	alias n='notepad.exe'
    _jyi_safe_add_path "/mnt/d/bin"
    _jyi_safe_add_path "/mnt/c/Program Files (x86)/Arduino"
fi

mkdir -p ~/.local/share/vim/shada/
mkdir -p ~/.local/share/vim/swap/
mkdir -p ~/.local/share/vim/undo/
