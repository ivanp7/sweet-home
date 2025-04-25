#!/bin/sh

export SXHKD_DIR="${XDG_CONFIG_HOME:-"$HOME/.config"}/sxhkd"
sxhkd "$@" &
echo "$!" > "$TMPDIR_SESSION/sxhkd.pid"

