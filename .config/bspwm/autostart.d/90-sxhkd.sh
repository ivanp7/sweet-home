#!/bin/sh

sleep 1

SXHKD_DIR="${XDG_CONFIG_HOME:-"$HOME/.config"}/sxhkd"

if [ ! -d "$SXHKD_DIR/conf.d" ]
then
    exec sxhkd
else
    find "$SXHKD_DIR/conf.d" -type f,l | sort | xargs -rd'\n' "$SXHKD_DIR/exec.sh"

