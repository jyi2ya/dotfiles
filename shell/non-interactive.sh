#!/bin/sh

_jyi_safe_add_path() {
    if [ -d "$1" ]; then
        case ":$PATH:" in
            *":$1:"*)
                ;;
            *)
                PATH="$1:$PATH"
                export PATH
                ;;
        esac
    fi
}

_jyi_safe_add_path "$HOME/.cargo/bin"
_jyi_safe_add_path "$HOME/.bin"
_jyi_safe_add_path "$HOME/.local/bin"
_jyi_safe_add_path "$HOME/bin"

if [ -z "$PNPM_HOME" ]; then
    export PNPM_HOME="$HOME/.local/share/pnpm"
    _jyi_safe_add_path "$PNPM_HOME"
fi

if [ -z "$NPM_CONFIG_PREFIX" ]; then
    NPM_CONFIG_PREFIX="$HOME/.local/"
    export NPM_CONFIG_PREFIX
fi

if [ -z "$NPM_CONFIG_PREFIX" ]; then
    WINEDEBUG=-all
    export WINEDEBUG
fi

if [ -r "$HOME/.cargo/env" ]; then
    . "$HOME/.cargo/env"
fi

if [ -z "$GOPATH" ]; then
    GOPATH="$HOME/.cargo"
    export GOPATH
fi

export PATH
