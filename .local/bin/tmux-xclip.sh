#!/bin/sh

exec tmux set-buffer "$(xclip -selection clipboard -o)"

