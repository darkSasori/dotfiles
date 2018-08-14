#!/bin/bash

# returns:
#   0: yes
#   1: no
#   2: default
#   *: exit
#
#
# examples:
#
# `test -f ~/.vimrc && test -f ~/.tmux.conf`
# option "~/.vimrc of ~/.tmux.conf already exists" "continue [Y,n]"
# `hash tmuxp 2>/dev/null`
# option "tmuxp not installed" "continue [y,N]"
option () {
    if [ $? != 0 ]; then
        echo $1
        echo -n "$2 "
        read -n 1 op
        if [ "$op" != "" ]; then echo; fi
        case $op in
            "y") return 0 ;;
            "Y") return 0 ;;
            "n") return 1 ;;
            "N") return 1 ;;
            "") return 2; ;;
            *) echo "invalid option"; exit 1 ;;
        esac
    fi
    return 0
}

# Exit by default
#
# examples:
#
# `test -f ~/.vimrc && test -f ~/.tmux.conf`
# option "~/.vimrc of ~/.tmux.conf already exists"
# `hash tmuxp 2>/dev/null`
# option "tmuxp not installed"
option_stop () {
    option $? "$1" "continue [y,N]"
    if [ $? != 0 ]; then exit; fi
}

# Continue by default
#
# examples:
#
# `test -f ~/.vimrc && test -f ~/.tmux.conf`
# option "~/.vimrc of ~/.tmux.conf already exists"
# `hash tmuxp 2>/dev/null`
# option "tmuxp not installed"
option_skip () {
    option "$1" "skip [Y,n]"
    if [ $? == 1 ]; then exit; fi
}

# Stop if test fail
#
# examples:
#
# `test -f ~/.vimrc && test -f ~/.tmux.conf`
# option "~/.vimrc of ~/.tmux.conf already exists"
# `hash tmuxp 2>/dev/null`
# option "tmuxp not installed"
stop_if_fail () {
	if [ $? != 0 ]; then echo $1; exit 1; fi
}
