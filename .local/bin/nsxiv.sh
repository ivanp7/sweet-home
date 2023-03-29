#!/bin/bash

setsid -f nsxiv-wrapper.sh "$@" > /dev/null 2>&1 &

