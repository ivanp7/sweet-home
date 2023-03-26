#!/bin/sh

ID="$(xdotool selectwindow 2> /dev/null)"
[ -z "$ID" ] || xkill -id "$ID"

