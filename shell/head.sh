#!/bin/sh

case $- in
    *i*) ;;
      *) return;;
esac

export LC_ALL=C.UTF-8
unset LANG LANGUAGE

jf() {
    tmux attach-session -t X || tmux new-session -s X
}

unalias -a
alias fj=jf
