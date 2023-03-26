#!/bin/sh

: ${STEP:=10}

case "$1" in
    up)   xbacklight -inc "$STEP" ;;
    down) xbacklight -dec "$STEP" ;;
    "") echo "$(xbacklight -get)%" ;;
    *) xbacklight -set "$1" ;;
esac

