#!/bin/sh

LINK="$(realpath -s -- "$1")"

if [ ! -L "$LINK" ]
then
    echo "'$LINK' is not a symlink."
    exit 1
fi

LINK_PATH="$(readlink "$LINK")"
NEW_LINK_PATH="$(echo "$LINK_PATH" | vipe)"
[ "$LINK_PATH" = "$NEW_LINK_PATH" ] || ln -sfT "$NEW_LINK_PATH" "$LINK"

