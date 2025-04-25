#!/bin/sh

DIR="$(dirname -- "$0")"

SXHKD_PID="$(cat -- "$TMPDIR_SESSION/sxhkd.pid")"
kill "$SXHKD_PID"
exec "$DIR/start.sh"

