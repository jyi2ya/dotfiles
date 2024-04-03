#!/bin/sh

alias rl='exec busybox ash -l'

HISTFILE="$HOME/.ash_history"
HISTFILESIZE=999999999

LAST_LS=$(command ls -xw 80 | sum)
LAST_PWD="$PWD"

_prompt_show_return_value()
{
    prompt_return_value=$?
	test $prompt_return_value -ne 0 && printf '[%s] ' $prompt_return_value
}

_prompt_smart_ls()
{
	smart_ls_this_ls=$(command ls -xw 80 | sum)
	if [ "$LAST_LS" != "$smart_ls_this_ls" ] || [ "$LAST_PWD" != "$PWD" ]; then
		LAST_LS="$smart_ls_this_ls"
		LAST_PWD="$PWD"
        ls -xw 80
        printf "@"
        return
	fi
}

_prompt_fish_path()
{
    awk '
BEGIN {
    pwd = ENVIRON["PWD"];
    home = ENVIRON["HOME"];
    pwd_items_len = split(pwd, pwd_items, "/");
    home_items_len = split(home, home_items, "/");

    i = 1;
    while (i <= home_items_len && pwd_items[i] == home_items[i])
        ++i;

    if (i > home_items_len) {
        printf("~");
    } else {
        i = 2;
    }

    while (i <= pwd_items_len - 2) {
        printf("/%s", substr(pwd_items[i], 1, 2));
        ++i;
    }

    while (i <= pwd_items_len) {
        printf("/%s", pwd_items[i]);
        ++i;
    }

    exit(0);
}
'
}

PS1='$(_prompt_smart_ls)$(_prompt_show_return_value)\H \A $(_prompt_fish_path)\n\$ '
