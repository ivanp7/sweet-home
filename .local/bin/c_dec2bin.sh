#!/bin/sh

DEC="$@"
DEC="$(echo "$DEC" | tr -d ' ')"
echo "$DEC" | grep -q "[^0-9]" && exit 1

BIN="$(echo "obase=2; ibase=10; $DEC" | bc)"
[ "$LEN" ] && echo "$BIN" | c_len.sh "$LEN" || echo "$BIN"

