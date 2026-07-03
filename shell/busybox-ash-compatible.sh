#!/bin/sh

alias rl='exec busybox ash -l'

HISTFILE="$HOME/.ash_history"
HISTFILESIZE=999999999

LAST_DIR_CHANGE=$(stat -c %Y . 2>/dev/null)
LAST_DIR_FINGERPRINT=$(command ls -A -1 2>/dev/null | cksum)
LAST_PWD="$PWD"

_prompt_show_return_value()
{
    prompt_return_value=$?
	test $prompt_return_value -ne 0 && printf '[%s] ' $prompt_return_value
}

_prompt_smart_ls()
{
    smart_ls_this_dir_change=$(stat -c %Y . 2>/dev/null) || return

    if [ "$LAST_PWD" = "$PWD" ] && [ "$LAST_DIR_CHANGE" = "$smart_ls_this_dir_change" ]; then
        return
    fi

    smart_ls_this_dir_fingerprint=$(command ls -A -1 2>/dev/null | cksum)
    if [ "$LAST_PWD" = "$PWD" ] && [ "$LAST_DIR_FINGERPRINT" = "$smart_ls_this_dir_fingerprint" ]; then
        LAST_DIR_CHANGE="$smart_ls_this_dir_change"
        return
    fi

    LAST_DIR_CHANGE="$smart_ls_this_dir_change"
    LAST_DIR_FINGERPRINT="$smart_ls_this_dir_fingerprint"
    LAST_PWD="$PWD"
    ls -xw 80
    printf "@"
    return
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
        printf("/%s", substr(pwd_items[i], 1, 3));
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
