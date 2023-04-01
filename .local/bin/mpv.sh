#!/bin/sh

setsid -f mpv-wrapper.sh --no-terminal --force-window=yes "$@" > /dev/null 2>&1 &

