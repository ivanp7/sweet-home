#!/bin/sh

setsid -f mpv-wrapper.sh "$@" > /dev/null 2>&1 &

