#!/bin/sh

sleep 1

if [ ! -d "$XDG_CONFIG_HOME/sxhkd/conf.d" ]
then
    exec sxhkd
else
    find "${XDG_CONFIG_HOME:-"$HOME/.config"}/sxhkd/conf.d" -type f,l |
        sort | exec xargs -rd'\n' sxhkd
fi

