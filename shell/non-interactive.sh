#!/bin/sh

_jyi_command_exists() {
    { command -v "$1" || which "$1"; } >/dev/null 2>&1
}

_jyi_safe_add_path() {
    for _jyi_safe_add_path_path in "$@"; do
        if [ -d "$_jyi_safe_add_path_path" ]; then
            case ":$PATH:" in
                *":$_jyi_safe_add_path_path:"*)
                    ;;
                *)
                    PATH="$_jyi_safe_add_path_path:$PATH"
                    ;;
            esac
        fi
    done
    export PATH
}

if [ -z "$PATH" ]; then
    PATH="/bin"
    export PATH
fi

_jyi_safe_add_path /usr/games /usr/local/games
_jyi_safe_add_path /sbin /bin /usr/sbin /usr/bin
_jyi_safe_add_path /usr/local/sbin /usr/local/bin /opt/sbin /opt/bin
_jyi_safe_add_path "$HOME/sbin" "$HOME/bin" "$HOME/.bin" "$HOME/.sbin"
_jyi_safe_add_path "$HOME/.local/bin" "$HOME/.local/sbin"
_jyi_safe_add_path "$HOME/.cargo/bin"

if [ -z "$PNPM_HOME" ]; then
    export PNPM_HOME="$HOME/.local/share/pnpm"
    _jyi_safe_add_path "$PNPM_HOME"
fi

if [ -z "$NPM_CONFIG_PREFIX" ]; then
    NPM_CONFIG_PREFIX="$HOME/.local"
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

if _jyi_command_exists vi; then
    EDITOR="vi"
    VISUAL=vi
    export EDITOR VISUAL
fi

if _jyi_command_exists vim; then
    EDITOR="vim"
    VISUAL=vim
    export EDITOR VISUAL
fi


if _jyi_command_exists less; then
    PAGER="less"
    export PAGER
fi
