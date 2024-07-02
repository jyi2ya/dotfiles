#!/bin/sh

umask 022

# safety
alias mv='mv -i'
alias cp='cp -i'
alias ln='ln -i'
alias rm='rm -I --preserve-root'
alias chown='chown'
alias chmod='chmod --preserve-root'
alias chgrp='chgrp --preserve-root'

# Git
alias cg='cd `git rev-parse --show-toplevel || echo .`'
alias gaA='git add -A'
alias gad='git add'
alias gbc='git branch'
alias gcm='git commit'
alias gco='git checkout'
alias gst='git status'
alias glg='git log --graph'
alias gmg='git merge'
alias gdf='git diff'
alias gps='git push'
alias gpl='git pull'
alias gin='git init'
alias gbl='git blame'
alias grm='git rm'

if command_exists xclip; then
    gcl() {
        if [ -n "$1" ]; then
            git clone "$@"
        else
            git clone "$(xclip -selection clipboard -o)"
        fi
    }
else
    alias gcl='git clone'
fi

# gcc
alias cc='cc -std=c11 -Wall -Werror -Wshadow -Og -g -fsanitize=address -pedantic'

# rust
alias cr='cargo run'
alias crr='cargo run --release'
alias co='cargo doc --open'
alias cb='cargo build --release'
alias ci='cargo init'
alias cl='cargo rustc -- --emit=llvm-ir'
alias cu='cargo update'
alias rc='rustc'

rr() {
	[ $# = 0 ] && return

    (
    rr_fname="/tmp/rust_run_$$.bin"
    rustc "$@" -o "$rr_fname" || return
    eval "$rr_fname"
    rm -f "$rr_fname"
    )
}

cn() {
	[ $# = 0 ] && return
	cargo new "$@"
	for cn_opt in "$@"; do
		if [ -d "$cn_opt" ]; then
			cd "$cn_opt" || return # make shellcheck happy
			return
		fi
	done
}

if command_exists sudo; then
    alias sudo='sudo '
    alias apt='sudo apt'
    alias reboot='sudo reboot'
    alias root='sudo su -'
    alias rbt='reboot'
    alias poweroff='sudo poweroff'
fi

# apt
alias sa='apt'
alias au='apt update && apt upgrade && apt full-upgrade && apt autoremove && sudo apt-file update'
alias ai='apt install'
alias ali='apt list --installed'
alias al='apt list'
alias af='apt-file -x find'
alias ap='apt purge'
alias aar='apt autoremove'

# docker
alias dr='docker run'
alias dps='docker ps'
alias dl='docker load'
alias di='docker image'
alias dc='docker container'

# ls
alias la='ls -A'
alias ll='ls -lh'
alias lt='ls --human-readable --size -1 -S --classify'
alias ls='ls -F'

# grep
alias xg='xargs -0 grep'
alias gv='grep -v'
alias gi='grep -i'
alias giv='grep -vi'
alias ge='egrep'

# Single-char aliases
alias a='ls -A'

c() {
	if [ -t 0 ] && [ "$#" -ge 2 ]; then
		cp "$@"
	else
		clip "$@"
	fi
}

alias d='docker'
alias e='unar'

f() {
	if [ -t 0 ]; then
        if [ $# -eq 0 ]; then
            find .
        elif [ $# -eq 1 ] && [ -d "$1" ]; then
            find "$@"
        else
            f_want_find=n
            for f_local_i in "$@"; do
                if [ "${f_local_i%"${f_local_i#?}"}" != '-' ] && ! [ -e "$f_local_i" ] && ! [ -h "$f_local_i" ]; then
                    f_want_find=y
                    break
                fi
            done
            if [ "$f_want_find" = y ]; then
                find "$@"
            else
                file "$@"
            fi
        fi
    else
		file -
    fi
}

g() {
    if [ $# = 0 ]; then
        git status
    else
        grep "$@"
    fi
}

alias h='head'
alias i='apt install'

j() {
    if [ $# = 0 ]; then
        jobs -l
    else
        diary-add "$@"
    fi
}

alias k='kubectl'

l() {
    if [ -t 0 ]; then
        if [ -t 1 ]; then
            if [ $# = 0 ]; then
                command ls -F
            else
                command ls -Flh "$@"
            fi
        else
            if [ $# = 0 ]; then
                command ls -1
            else
                command ls -d1 "$@"
            fi
        fi
    else
        wc -l "$@"
    fi
}

m() {
	if [ $# = 0 ]; then
        make
	elif [ $# = 1 ] && [ -f "$1" ]; then
		mv "$1" .
    elif [ $# = 1 ]; then
        man "$1"
    else
		mv "$@"
	fi
}

alias o='xdg-open'

p_func() {
	if [ -t 0 ]; then
        if [ $# = 0 ]; then
            pueue status
        elif [ -r "$1" ]; then
            less "$@"
        else
            pueue "$@"
        fi
	else
        if [ $# = 0 ]; then
            less "$@"
        elif [ $# = 1 ] && [ "$1" = '-R' ]; then
            less "$@"
        else
            parallel "$@"
        fi
	fi
}

alias p='p_func '

alias r='rm'

s() {
    if [ -t 0 ]; then
        ssh "$@"
    else
        sort "$@"
    fi
}

t() {
    if [ -t 0 ]; then
        task "$@"
    else
        tail "$@"
    fi
}

u() {
    if [ -t 0 ]; then
        au "$@"
    else
        uniq "$@"
    fi
}

alias v='vi'

w() {
    if [ -t 0 ]; then
        if [ $# = 0 ]; then
            command w
        else
            command -v "$@"
        fi
    else
        wc "$@"
    fi
}

alias x='xargs '
alias y='yes'

# Tools
alias ....='cd ../../../'
alias ...='cd ../..'
alias bc='bc -lq'
alias chomp='tr -d "\n"'
alias cls='clear'
alias cow='curseofwar -W18 -H20'
alias cpv='rsync -ah --info=progress2'
alias cr='cargo run'
alias ct='column -t'
alias fmt='fmt -s'
alias gb='iconv -fgb18030 -tutf8'
alias ipa='ip a'
alias jt='jrnl @tech'
alias mkd='mkdir'
alias nms='nms -cs -f white'
alias nsend='nc -Nnvlp 6737 -q 1'
alias pad='pueue add '
alias rl='exec dash -l'
alias sck='shellcheck -Cauto -s sh'
alias sr='sort -R'
alias tf='tail -f'
alias vdf='vimdiff'
alias wk='genact -m cc'
alias gl='glow -s light -p'
alias wl='wc -l'
alias pp='parallel --pipe -k '
alias pr='parallel'
alias tsi='ts -i "%H:%M:%.S"'
alias mj='make -j$(nproc)'
alias watch='watch -c'
alias diff='diff --color=auto'
alias grep='grep --color=auto'
alias dmesg='dmesg -HL'
alias ip='ip -c=auto'

if ! command_exists rg; then
    alias rg='grep -rE'
fi

idle() {
    renice -n 19 -p $$
    chrt -i -p 0 $$
    ionice -c3 -p $$
}

vw() {
    vi "$(which "$@")"
}

fw() {
    file "$(which "$@")"
}

md()
{
	if [ -z "$2" ]; then
		mkdir "$1" || return
		cd "$1" || return # make shellcheck happy
	else
		mkdir "$@"
	fi
}

fk() {
    if command_exists fzf; then
        fk_pid=$(ps -ef | sed 1d | fzf -m --tac | awk '{print $2}')

        if [ -n "$fk_pid" ]; then
            echo "$fk_pid" | xargs kill -"${1:-9}"
        fi
    fi
}

oe() {
    [ -z "$1" ] && return 1
    nohup xdg-open "$@" >/dev/null 2>&1 &
    exit
}

# Vim
if command_exists vi >/dev/null; then
    EDITOR="vi"
    VISUAL=vi
fi

if command_exists vim >/dev/null; then
    EDITOR="vim"
    VISUAL=vim
    alias vi='vim'
fi

export EDITOR VISUAL

# Fix typo
alias lw='wl'
alias sl='ls'
alias iv='vi'
alias josb='jobs'
alias lr='rl'
alias dm='md'
alias ig='gi'
alias oo='o'
alias ooo='o'
alias cla='cal'

for path in "$HOME/.bin" "$HOME/.local/bin" "$HOME/bin"; do
    PATH="$path${PATH:+":"}$PATH"
done

export PATH

PS1="$USER@$(uname -n)"
if [ "$(id -u)" = 0 ]; then
    PS1="$PS1 # "
else
    PS1="$PS1 \$ "
fi
