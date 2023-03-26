#!/bin/sh

XEV_NAME="xev -- X event tester"

bspc rule --add "*:*:$XEV_NAME" --one-shot state=floating
xev -rv -name "$XEV_NAME"

