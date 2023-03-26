#!/bin/sh

: ${DMENU_PROMPT:="Window"}
: ${DMENU_LINES:=10}
: ${DMENU_COLUMNS:=2}

WINDOW_ID="$(for id in $(bspc query -N -n .window.!hidden)
do
    echo "$id @ [$((1 + $(xdotool get_desktop_for_window "$id")))]: $(xdotool getwindowclassname "$id") \"$(xdotool getwindowname "$id")\""
done | dmenu -p "$DMENU_PROMPT" -l "$DMENU_LINES" -g "$DMENU_COLUMNS" | head -1 | cut -d' ' -f 1)"

[ -z "$WINDOW_ID" ] || bspc node "$WINDOW_ID" --focus

