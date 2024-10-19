#!/bin/sh
set -u

TEMP_FILE="$(mktemp -p "$TMPDIR_SESSION" "nsxiv-xclip.XXXXXX")"

clean_exit ()
{
    [ ! -f "${TEMP_FILE:-}" ] || rm -f -- "$TEMP_FILE"
    trap - EXIT
    exit ${1:-}
}
trap 'clean_exit $?' EXIT ${TRAPPED_SIGNALS:-}

xclip -selection clipboard -target image/png -out > "$TEMP_FILE"
nsxiv.sh "$TEMP_FILE"
sleep 1

clean_exit

