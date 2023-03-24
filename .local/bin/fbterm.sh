#!/bin/sh

[ "$TERM" = "linux" ] || exit

: ${FBTERM_WALLPAPER:="$HOME/wallpapers/fbterm"}

if [ -r "$FBTERM_WALLPAPER" ] && file --mime-type "$FBTERM_WALLPAPER" -bLE | grep -q "^image/"
then
    echo -ne "\e[?25l" # hide cursor
    fbv -ciuker "$FBTERM_WALLPAPER" << EOF
q
EOF
    export FBTERM_BACKGROUND_IMAGE=1
fi

exec fbterm -- "${XDG_CONFIG_HOME:-"$HOME/.config"}/fbterm/init.sh" "$1"

