#!/bin/sh

sleep 2

if [ ! -d "$XDG_CONFIG_HOME/sxhkd/conf.d" ]
then
    sxhkd
else
    find "${XDG_CONFIG_HOME:-"$HOME/.config"}/sxhkd/conf.d" -type f,l |
        sort | xargs -rd'\n' sxhkd
fi

