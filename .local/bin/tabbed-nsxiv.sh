#!/bin/sh

nohup tabbed.sh -e nsxiv-wrapper.sh "$@" > /dev/null 2>&1 &

