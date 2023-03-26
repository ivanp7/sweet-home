#!/bin/sh

CLASS="$1"
[ "$CLASS" ] || exit 1

case "$2" in
    show) act="=off" ;;
    hide) act="=on" ;;
    *) act="" ;;
esac

for pid in $(xdotool search --class "^$CLASS\$")
do
    bspc node "$pid" --flag hidden$act --focus
done

