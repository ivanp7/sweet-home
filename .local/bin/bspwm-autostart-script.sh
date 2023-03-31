#!/bin/sh

. "$HOME/.local/env.shell"

SCRIPT="$1"
shift 1

"$XDG_CONFIG_HOME/bspwm/autostart.d/$SCRIPT" "$@"

