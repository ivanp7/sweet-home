#!/bin/sh

. "$HOME/.local/env.shell"

SCRIPT="$1"
shift 1

"$XDG_CONFIG_HOME/bspwm/autostart_sync.d/$SCRIPT" "$@"

