#!/bin/sh

setsid -f tabbed.sh -w st "$@" > /dev/null 2>&1 &

