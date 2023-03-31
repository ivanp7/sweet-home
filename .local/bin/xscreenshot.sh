#!/bin/sh
set -e

if [ ! -t 1 ] # pipe
then
    maim "$@"
    exit
fi

: ${FILENAME_PREFIX:="screenshot"}
: ${FILENAME:="${FILENAME_PREFIX}_$(date "+%F_%T").png"}

TEMP_DIRECTORY="$TMPDIR_SESSION/screenshot"
mkdir -p -- "$TEMP_DIRECTORY"

maim "$@" -- "$TEMP_DIRECTORY/$FILENAME"

DMENU_PROMPT="Screenshot directory"
: ${DMENU_LINES:=10}
: ${DMENU_COLUMNS:=4}

HISTORY_FILE="$XDG_CACHE_HOME/screenshot-history"
touch -- "$HISTORY_FILE"

INPUT=$(tac -- "$HISTORY_FILE" | dmenu -p "$DMENU_PROMPT" -l "$DMENU_LINES" -g "$DMENU_COLUMNS" | head -1)
if [ -z "$INPUT" ] || ! cp -t "$INPUT" -- "$TEMP_DIRECTORY/$FILENAME"
then
    echo "$TEMP_DIRECTORY/$FILENAME"
    exit
fi

{ grep -Fxv "$INPUT" -- "$HISTORY_FILE"; echo "$INPUT"; } | sponge -- "$HISTORY_FILE"

echo "$INPUT/$FILENAME"

