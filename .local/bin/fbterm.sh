#!/bin/sh

[ "$TERM" = "linux" ] || exit

: ${XDG_CONFIG_HOME:-"$HOME/.config"}

: ${FRAMEBUFFER:="/dev/fb0"}
: ${FBTERM_WALLPAPER:="$XDG_CONFIG_HOME/fbterm/wallpaper.fbimg"}

if [ -r "$FBTERM_WALLPAPER" ]
then
    export FBTERM_BACKGROUND_IMAGE=1
    cat "$FBTERM_WALLPAPER"  > "$FRAMEBUFFER"
fi

exec fbterm -- "$XDG_CONFIG_HOME/fbterm/init.sh" "$1"

