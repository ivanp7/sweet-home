#!/bin/sh

DMENU_PROMPT="[Section] Page"
: ${DMENU_LINES:=20}
: ${DMENU_COLUMNS:=10}

HISTORY_FILE="$XDG_CACHE_HOME/man-history"
touch -- "$HISTORY_FILE"

INPUT=$(tac -- "$HISTORY_FILE" | uniq | dmenu.sh -p "$DMENU_PROMPT" -l "$DMENU_LINES" -g "$DMENU_COLUMNS" | head -1)
[ "$INPUT" ] || exit

SCRATCHPAD="${SCRATCHPAD_MAN:-0}" scratchpad-st.sh -t "$INPUT" -e man $INPUT

{ grep -Fxv "$INPUT" -- "$HISTORY_FILE"; echo "$INPUT"; } | sponge -- "$HISTORY_FILE"

