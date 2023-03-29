#!/bin/sh
set -u

if [ "${TABBED_CLASS:-}" ]
then
    TABBED_CLASS_FILE="$TMPDIR_SESSION/tabbed/$TABBED_CLASS"
    : ${TABBED_XID:="$(cat -- "$TABBED_CLASS_FILE" 2> /dev/null)"}
fi

XEMBED_FLAG="$1"
COMMAND="$2"
shift 2

if [ "${TABBED_XID:-}" ]
then
    exec "$COMMAND" "$XEMBED_FLAG" "$TABBED_XID" "$@"
else
    if [ "${TABBED_CLASS:-}" ]
    then
        mkdir -p -- "$(dirname -- "$TABBED_CLASS_FILE")"
        trap 'rm -f -- "$TABBED_CLASS_FILE"' EXIT

        tabbed -c -w "$TABBED_CLASS" -r 2 "$COMMAND" "$XEMBED_FLAG" xid "$@" > "$TABBED_CLASS_FILE"
    else
        exec tabbed -c -r 2 "$COMMAND" "$XEMBED_FLAG" xid "$@"
    fi
fi

