#!/bin/sh

BIN="$@"
BIN="$(echo "$BIN" | tr -d ' ')"
echo "$BIN" | grep -q "[^01]" && exit 1

HEX="$(echo "obase=16; ibase=2; $BIN" | bc)"
[ "$LEN" ] && echo "$HEX" | c_len.sh "$LEN" || echo "$HEX"

