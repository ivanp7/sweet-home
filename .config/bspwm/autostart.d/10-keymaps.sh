#!/bin/sh

sleep 1

# load keymaps
sysmodmap="/etc/X11/xinit/xmodmap.d"
[ ! -d "$sysmodmap" ] ||
for file in $(find "$sysmodmap" -type f,l)
do
    xmodmap "$file"
done

usermodmap="${XDG_CONFIG_HOME:-"$HOME/.config"}/X11/xmodmap.d"
[ ! -d "$usermodmap" ] ||
for file in $(find "$usermodmap" -type f,l)
do
    xmodmap "$file"
done

