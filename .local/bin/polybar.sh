#!/bin/sh
set -u

: ${WINDOW_TITLE_FORMAT:="%title:0:$(($(bspwm-monitor-info.sh width) / $DEFAULT_FONT_WIDTH * 5/12)):...%"}
: ${FONT:="$DEFAULT_FONT;0"}
: ${PREFIX:="$(cat /sys/class/tty/tty0/active):$(id -un)"}

: ${MONITOR:="$(bspwm-monitor-info.sh name ${1:-focused})"}

export WINDOW_TITLE_FORMAT FONT PREFIX MONITOR

setsid -f polybar --reload ${2:-top} > /dev/null 2>&1 &

