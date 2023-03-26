#!/bin/sh

. "$HOME/.local/env.shell"

cd

# start X server
exec startx "$XINITRC" -- "$XSERVERRC"

