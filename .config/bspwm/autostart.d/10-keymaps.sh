#!/bin/sh

sleep 1

# load keymaps
sysmodmap="/etc/X11/xinit/.Xmodmap"
[ ! -f "$sysmodmap" ] || xmodmap "$sysmodmap"

usermodmap="${XDG_CONFIG_HOME:-"$HOME/.config"}/X11/xmodmap.d"
[ ! -d "$usermodmap" ] ||
for file in $(find "$usermodmap" -type f,l)
do
    xmodmap "$file"
done

