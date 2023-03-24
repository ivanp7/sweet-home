#!/bin/sh

[ "$TERM" = "linux" ] || exit

: ${FRAMEBUFFER:="/dev/fb0"}

: ${FBTERM_WALLPAPER:="$HOME/wallpapers/fbterm.fbimg"}

if [ -r "$FBTERM_WALLPAPER" ]
then
    export FBTERM_BACKGROUND_IMAGE=1
    cat "$FBTERM_WALLPAPER"  > "$FRAMEBUFFER"
fi

exec fbterm -- "${XDG_CONFIG_HOME:-"$HOME/.config"}/fbterm/init.sh" "$1"

