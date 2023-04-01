#!/bin/sh

SCRIPT="$1"
shift 1

"$XDG_CONFIG_HOME/bspwm/autostart.d/$SCRIPT" "$@"

