#!/bin/sh

: ${SCRATCHPAD:=${SCRATCHPAD_ST:-0}}
export TABBED_CLASS="scratchpad_$SCRATCHPAD"

bspwm-scratchpad.sh "$TABBED_CLASS" show
exec tabbed-st.sh "$@"

