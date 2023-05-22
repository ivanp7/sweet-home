#!/bin/sh

DMENU_PROMPT="Expression"
: ${DMENU_LINES:=20}
: ${DMENU_COLUMNS:=4}

: ${NOTIFY_TIME:=5000}

HISTORY_FILE="$XDG_CACHE_HOME/calculator-history"
touch -- "$HISTORY_FILE"

INPUT=$(tac -- "$HISTORY_FILE" | dmenu.sh -p "$DMENU_PROMPT" -l "$DMENU_LINES" -g "$DMENU_COLUMNS" | head -1)
[ "$INPUT" ] || exit

RESULT="$(calc.sh "$INPUT" 2>&1)"
if [ "$?" -eq 0 ]
then
    { grep -Fxv -e "$INPUT" -- "$HISTORY_FILE" || true; echo "$INPUT"; } | sponge -- "$HISTORY_FILE"

    notify-send -t "$NOTIFY_TIME" -u normal -- "Calculator" "$RESULT"
else
    notify-send -t "$NOTIFY_TIME" -u critical -- "Calculator" "error"
fi

