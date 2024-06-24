#!/bin/sh

case $- in
    *i*) ;;
      *) return;;
esac

command_exists() {
    { command -v "$1" || which "$1"; } >/dev/null
}

jf() {
    tmux attach-session -t X || tmux new-session -s X
}

unalias -a
alias fj=jf
