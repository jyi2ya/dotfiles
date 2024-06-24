#!/bin/bash

alias -- -='cd -'
alias rl='exec -l bash'

shopt -s autocd
shopt -s checkwinsize
shopt -s dotglob
# shopt -s failglob
shopt -s globstar
shopt -s histappend

HISTSIZE="-1"
HISTFILESIZE="-1"
HISTFILE="$HOME/.bash_history"
HISTTIMEFORMAT="%F %T "
HISTCONTROL=ignoredups
INPUTRC=/etc/inputrc

save_history() {
    history -a
    history -c
    history -r
}

trap save_history EXIT

export PAGER="less"
export LESS="-R -i -g -W"
export LESSOPEN='|/usr/bin/lesspipe %s'
export LESSCLOSE='/usr/bin/lesspipe %s %s'
# color man
export LESS_TERMCAP_mb=$'\E[01;31m'
export LESS_TERMCAP_md=$'\E[01;31m'
export LESS_TERMCAP_me=$'\E[0m'
export LESS_TERMCAP_se=$'\E[0m'
export LESS_TERMCAP_so=$'\E[01;44;33m'
export LESS_TERMCAP_ue=$'\E[0m'
export LESS_TERMCAP_us=$'\E[01;32m'

LAST_DIR_CHANGE=$(stat -c %Z .)
LAST_PWD="$PWD"
_prompt_smart_ls()
{
    local this_dir_change this_pwd this_ls
    this_pwd=$PWD
    if [ "$this_pwd" == "$LAST_PWD" ]; then
        this_dir_change=$(stat -c %Z .)
        if [ "$this_dir_change" == "$LAST_DIR_CHANGE" ]; then
            return
        fi
    fi

    LAST_PWD=$this_pwd
    LAST_DIR_CHANGE=$this_dir_change
    ls
    return
}

_prompt_slow_command_tracer_init()
{
    CMD_START_TIME="$SECONDS"
    if [ -n "$DISPLAY" ]; then
        CMD_ACTIVE_WINDOW=$(xdotool getactivewindow 2>/dev/null)
    fi
}

_prompt_set_return_value() {
    prompt_return_value=$?
}

_prompt_show_return_value()
{
	test $prompt_return_value -ne 0 && printf '[%s] ' $prompt_return_value
}

_prompt_slow_command()
{
    local time_diff=$((SECONDS - CMD_START_TIME))
    local active_window
    local urgency="low"
    if [ "$prompt_return_value" != 0 ]; then
        urgency=critical
    fi

    if [ -n "$DISPLAY" ]; then
        active_window=$(xdotool getactivewindow 2>/dev/null)
        if [ -n "$CMD_ACTIVE_WINDOW" ] && [ "$active_window" != "$CMD_ACTIVE_WINDOW" ]; then
            notify-send -u "$urgency" "DONE $(date -u +%H:%M:%S --date="@$time_diff")" "$(fc -nl 0 | sed 's/^[[:space:]]*//')"
        fi
    fi
    [ $time_diff -lt 10  ] && return
    echo -n ">"
    date -u +%H:%M:%S --date="@$time_diff" | awk -F':' '{
    if ($1) printf("%dh ", $1);
    if ($1 || $2) printf("%dm ", $2);
    printf("%ds", $3);
}'
    echo -n "< "
    return
}

_prompt_append_history() {
    history -a
}

preexec_functions+=(_prompt_slow_command_tracer_init)
preexec_functions+=(_prompt_append_history)
precmd_functions+=(_prompt_smart_ls)
precmd_functions+=(_prompt_set_return_value)

if [ -r /usr/share/git/git-prompt.sh ]; then
    . /usr/share/git/git-prompt.sh
fi

if command -v __git_ps1 > /dev/null; then
    PS1='$(_prompt_show_return_value)$(_prompt_slow_command)\H \A$(__git_ps1) $(_prompt_fish_path)\n\j '
else
    PS1='$(_prompt_show_return_value)$(_prompt_slow_command)\H \A $(_prompt_fish_path)\n\j '
fi

# shellcheck shell=sh disable=SC1091,SC2039,SC2166
# Check for interactive bash and that we haven't already been sourced.
if [ "x${BASH_VERSION-}" != x -a "x${PS1-}" != x -a "x${BASH_COMPLETION_VERSINFO-}" = x ]; then

    # Check for recent enough version of bash.
    if [ "${BASH_VERSINFO[0]}" -gt 4 ] ||
        [ "${BASH_VERSINFO[0]}" -eq 4 -a "${BASH_VERSINFO[1]}" -ge 2 ]; then
        [ -r "${XDG_CONFIG_HOME:-$HOME/.config}/bash_completion" ] &&
            . "${XDG_CONFIG_HOME:-$HOME/.config}/bash_completion"
        if shopt -q progcomp && [ -r /usr/share/bash-completion/bash_completion ]; then
            # Source completion code.
            . /usr/share/bash-completion/bash_completion
        fi
    fi

fi
