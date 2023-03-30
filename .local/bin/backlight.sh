#!/bin/sh
set -eu

: ${DEVICE:="$(cd /sys/class/backlight; find . -mindepth 1 -maxdepth 1 -type d,l | head -1 | sed 's|^\./||')"}

[ "$DEVICE" ] || exit 1

MAX_BRIGHTNESS=$(cat "/sys/class/backlight/$DEVICE/max_brightness")
STEP=$(($MAX_BRIGHTNESS / 10))
BRIGHTNESS=$(cat "/sys/class/backlight/$DEVICE/brightness")
echo "$BRIGHTNESS/$MAX_BRIGHTNESS"

if [ "${1:-}" ]
then
    case "$1" in
        max) BRIGHTNESS=$MAX_BRIGHTNESS ;;
        up)   BRIGHTNESS=$(($BRIGHTNESS + $STEP)) ;;
        down) BRIGHTNESS=$(($BRIGHTNESS - $STEP)) ;;
        +*) BRIGHTNESS=$(($BRIGHTNESS $1)) ;;
        -*) BRIGHTNESS=$(($BRIGHTNESS $1)) ;;
        *) BRIGHTNESS="$1" ;;
    esac

    echo "$BRIGHTNESS" > "/sys/class/backlight/$DEVICE/brightness"

    BRIGHTNESS=$(cat "/sys/class/backlight/$DEVICE/brightness")
    echo "-> $BRIGHTNESS/$MAX_BRIGHTNESS"
fi

