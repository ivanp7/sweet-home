#!/bin/sh

SCRIPT="$1"
shift 1

"$XDG_CONFIG_HOME/bspwm/autostart_sync.d/$SCRIPT" "$@"

