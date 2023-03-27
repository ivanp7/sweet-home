#!/bin/sh

setsid -f st "$@" > /dev/null 2>&1 &

