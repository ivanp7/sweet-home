#!/bin/sh

setsid -f tabbed.sh --wid mpv-wrapper.sh "$@" > /dev/null 2>&1 &

