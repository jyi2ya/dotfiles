#!/bin/sh

case $- in
    *i*) ;;
      *) return;;
esac

export LC_ALL=C.UTF-8
unset LANG LANGUAGE

unalias -a
