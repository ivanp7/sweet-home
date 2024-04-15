#!/bin/sh

DMENU_PROMPT="Run"
: ${DMENU_LINES:=20}
: ${DMENU_COLUMNS:=4}

xkblayout.sh
dmenu_run -p "$DMENU_PROMPT" -l "$DMENU_LINES" -g "$DMENU_COLUMNS"

