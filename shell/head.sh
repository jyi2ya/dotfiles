#!/bin/sh

case $- in
    *i*) ;;
      *) return;;
esac

jf() {
    tmux attach-session -t X || tmux new-session -s X
}

alias fj=jf
