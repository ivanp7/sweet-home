#!/bin/sh

. "$HOME/.local/env.shell"

cd

# execute X server
exec startx "$XINITRC" -- "$XSERVERRC" 2> /dev/null

