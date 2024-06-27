#!/bin/sh

case $- in
    *i*) ;;
      *) return;;
esac

export LC_ALL=C.UTF-8
unset LANG LANGUAGE

command_exists() {
    { command -v "$1" || which "$1"; } >/dev/null
}

jf() {
    tmux attach-session -t X || tmux new-session -s X
}

unalias -a
alias fj=jf
