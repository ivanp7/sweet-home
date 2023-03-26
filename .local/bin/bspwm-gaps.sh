#!/bin/sh

: ${STEP:=5}

gaps ()
{
    bspc config window_gap $1
}

case "$1" in
    up)   gaps $(($(gaps) + $STEP)) ;;
    down) gaps $(($(gaps) - $STEP)) ;;
    "") gaps ;;
    *)  gaps "$1" ;;
esac

