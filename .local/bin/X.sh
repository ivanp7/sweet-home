#!/bin/sh

cd

# execute X server
exec startx "$XINITRC" -- "$XSERVERRC" 2> /dev/null

