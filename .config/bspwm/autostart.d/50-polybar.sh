#!/bin/sh
set -u

export WINDOW_TITLE_FORMAT="%title:0:$(($(bspwm-monitor-info.sh width) / $DEFAULT_FONT_WIDTH * 5/12)):...%"
export FONT="$DEFAULT_FONT;0"
export PREFIX="$(cat /sys/class/tty/tty0/active):$(id -un)"

MONITOR_PRIMARY="$(bspwm-monitor-info.sh name primary)"

MONITOR="$MONITOR_PRIMARY" polybar --reload top &

xrandr | sed '/ [0-9]\+x[0-9]\++[0-9]\++[0-9]\+ /!d; s/ .*//' | while IFS="
" read -r monitor
do
    [ "$monitor" = "$MONITOR_PRIMARY" ] || MONITOR="$monitor" polybar --reload top &
done

