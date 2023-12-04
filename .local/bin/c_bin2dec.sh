#!/bin/sh

BIN="$@"
BIN="$(echo "$BIN" | tr -d ' ')"
echo "$BIN" | grep -q "[^01]" && exit 1

DEC="$(echo "obase=10; ibase=2; $BIN" | bc)"
[ "$LEN" ] && echo "$DEC" | c_len.sh "$LEN" || echo "$DEC"

