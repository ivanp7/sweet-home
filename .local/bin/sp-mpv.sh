#!/bin/sh

: ${SCRATCHPAD:=${SCRATCHPAD_MEDIA:-0}}
export TABBED_CLASS="scratchpad_$SCRATCHPAD"

bspwm-scratchpad.sh "$TABBED_CLASS" show
exec tabbed-mpv.sh "$@"

