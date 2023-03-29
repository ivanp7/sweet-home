#!/bin/sh

DMENU_PROMPT="Tmux buffer"
: ${DMENU_LINES:=20}
: ${DMENU_COLUMNS:=2}

BUFFER="$(tmux list-buffers | dmenu -p "$DMENU_PROMPT" -l "$DMENU_LINES" -g "$DMENU_COLUMNS" | cut -d ':' -f 1)"
[ "$BUFFER" ] || exit

tmux save-buffer -b "$BUFFER" - | xclip -selection clipboard

