#!/bin/sh

BIN="$@"
BIN="$(echo "$BIN" | tr -d ' ')"
echo "$BIN" | grep -q "[^01]" && exit 1

OCT="$(echo "obase=8; ibase=2; $BIN" | bc)"
[ "$LEN" ] && echo "$OCT" | c_len.sh "$LEN" || echo "$OCT"

