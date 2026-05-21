#!/bin/sh

if [ "${OUT:-}" ];
then
    tty_arg="--tty $OUT"
else
    echo "\$OUT is not specified"
    exit 1
fi

if [ "${DASH:-}" ]
then
    dashboard_cmd="dashboard -output $DASH"
else
    echo "\$DASH is not specified"
    exit 1
fi

gdb -tui $tty_arg ${dashboard_cmd:+-ex "$dashboard_cmd"} --args "$@"

