#!/bin/sh

export TERM="fbterm"

cd

TMUX_SET_TITLES=$(tmux show -gvq set-titles)

tmux attach ${1:+-t "$1"} \; set -g set-titles off ||
    tmux new-session ${1:+-s "$1"} \; set -g set-titles off

tmux set -g set-titles ${TMUX_SET_TITLES:-off}

