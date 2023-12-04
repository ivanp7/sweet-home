#!/bin/sh

HEX="$@"
HEX="$(echo "$HEX" | tr -d ' ' | tr 'abcdef' 'ABCDEF')"
echo "$HEX" | grep -q "[^A-F0-9]" && exit 1

BIN="$(echo "obase=2; ibase=16; $HEX" | bc)"
[ "$LEN" ] && echo "$BIN" | c_len.sh "$LEN" || echo "$BIN"

