#!/bin/sh

LINK="$(realpath -s -- "$1")"

if [ ! -L "$LINK" ]
then
    echo "'$LINK' is not a symlink."
    exit 1
fi

LINK_PATH="$(readlink "$LINK")"

[ -d "$LINK_PATH" ] || exit 0

DIR="$(dirname -- "$LINK")"
NAME="$(basename -- "$LINK")"

cd -- "$DIR"
rm -- "$NAME" # remove symlink to directory
mkdir -- "$NAME" # create directory

case "$LINK_PATH" in
    /*) find "$LINK_PATH" -mindepth 1 -maxdepth 1 | xargs -I {} ln -s "{}" "$NAME/" ;;
    *)  find "$LINK_PATH" -mindepth 1 -maxdepth 1 | xargs -I {} ln -s "../{}" "$NAME/" ;;
esac

