#!/bin/sh

sleep 1

CONF_DIR="${XDG_CONFIG_HOME:-"$HOME/.config"}/sxhkd/conf.d"

if [ ! -d "$CONF_DIR" ]
then
    exec sxhkd
else
    cd -- "$CONF_DIR"
    find . -type f,l | sort | xargs -rd'\n' sxhkd
fi

