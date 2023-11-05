#!/bin/sh

nohup tabbed.sh --wid mpv-wrapper.sh --no-terminal --force-window=yes "$@" > /dev/null 2>&1 &

