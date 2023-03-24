#!/bin/sh

export TERM="fbterm"

cd

if [ -z "$1" ]
then tmux attach || tmux new-session -s default
else tmux attach -t "$1" || tmux new-session -s "$1"
fi

