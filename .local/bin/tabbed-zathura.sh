#!/bin/sh

setsid -f tabbed.sh -e zathura.sh "$@" > /dev/null 2>&1 &

