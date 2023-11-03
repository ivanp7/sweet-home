#!/bin/sh

SCRIPT="$1"
shift 1

exec "$XDG_CONFIG_HOME/bspwm/autostart.d/$SCRIPT" "$@"

