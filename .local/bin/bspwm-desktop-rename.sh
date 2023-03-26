#!/bin/sh

DESKTOP_NAME="$(dmenu.sh -p "Desktop name: " < /dev/null)"
[ -z "$DESKTOP_NAME" ] || bspc desktop -n "$DESKTOP_NAME"

