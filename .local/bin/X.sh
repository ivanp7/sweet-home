#!/bin/sh
set -u

cd

# execute X server
exec startx "$XINITRC" -- "$XSERVERRC" 2> /dev/null

