#!/bin/sh

WINDOW_ID="$(xdotool selectwindow)"

for node_id in $(bspc query -N -n .window)
do
    if [ "$(bspc query -T -n "$node_id" | jq ".id")" = "$WINDOW_ID" ]
    then
        echo "$node_id"
        exit 0
    fi
done

exit 1

