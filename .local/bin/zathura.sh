#!/bin/sh

setsid -f zathura "$@" > /dev/null 2>&1 &

