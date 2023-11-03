#!/bin/sh

INPUT="$1"
OUTPUT="${2:-"${XDG_CONFIG_HOME:-"$HOME/.config"}/fbterm/wallpaper.fbimg"}"

: ${FRAMEBUFFER:="/dev/fb0"}
: ${FBI_DELAY:=1}

if [ ! -r "$INPUT" ]
then
    echo "Error: no input image provided"
    exit 1
elif [ ! -d "$(dirname -- "$OUTPUT")" ]
then
    echo "Error: output directory does not exist"
    exit 1
elif [ "$(id -u)" -ne 0 ]
then
    echo "Error: this script is not run under root"
    exit 1
elif tty | grep -qv '^/dev/tty[0-9]\+$'
then
    echo "Error: this script is not run in framebuffer TTY"
    exit 1
fi

( sleep "$FBI_DELAY"; cat -- "$FRAMEBUFFER" > "$OUTPUT" ) &
fbi -noverbose -nocomments -nointeractive -autozoom -once \
    -timeout $(("$FBI_DELAY" * 2)) -device "$FRAMEBUFFER" "$INPUT"

