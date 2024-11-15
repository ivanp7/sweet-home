#!/bin/sh

: ${SCRATCHPAD:=${SCRATCHPAD_MEDIA:-0}}
export TABBED_CLASS="scratchpad_$SCRATCHPAD"

bspwm-scratchpad.sh "scratchpad_$SCRATCHPAD" show
exec tabbed-zathura.sh "$@"

