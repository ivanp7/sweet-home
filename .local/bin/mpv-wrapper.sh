#!/bin/sh

if [ "$1" = "--wid" ]
then
    WID="$2"
    shift 2

    MPV_ARGS="--wid=$WID --x11-wid-title=yes ${MPV_ARGS:-}"
fi

${VIDEO_ACCELERATOR:-} mpv ${MPV_ARGS:-} "$@"

