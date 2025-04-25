#!/bin/sh

DIR="$(dirname -- "$0")"

if [ ! -d "$DIR/conf.d" ]
then
    "$DIR/exec.sh"
else
    find "$DIR/conf.d" -type f,l | sort | xargs -rd'\n' "$DIR/exec.sh"
fi

