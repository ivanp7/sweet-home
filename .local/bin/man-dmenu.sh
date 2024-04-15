#!/bin/sh

DMENU_PROMPT="Page"
: ${DMENU_LINES:=30}
: ${DMENU_COLUMNS:=2}

HISTORY_FILE="$XDG_CACHE_HOME/man-history"
touch -- "$HISTORY_FILE"

INPUT=$(man -k "" | # tac -- "$HISTORY_FILE"
    uniq | dmenu.sh -p "$DMENU_PROMPT" -l "$DMENU_LINES" -g "$DMENU_COLUMNS" | head -1 |
    sed "s,^\(\S\+\) (\(\S\+\))\s\+-.*,\2 \1,")
[ "$INPUT" ] || exit

if man $INPUT > /dev/null 2>&1
then
    SCRATCHPAD="${SCRATCHPAD_MAN:-0}" scratchpad-st.sh -t "$INPUT - man" -e man $INPUT

    { grep -Fxv "$INPUT" -- "$HISTORY_FILE" || true; echo "$INPUT"; } | sponge -- "$HISTORY_FILE"
fi

