#!/bin/sh

HEX="$@"
HEX="$(echo "$HEX" | tr -d ' ' | tr 'abcdef' 'ABCDEF')"
echo "$HEX" | grep -q "[^A-F0-9]" && exit 1

DEC="$(echo "obase=10; ibase=16; $HEX" | bc)"
[ "$LEN" ] && echo "$DEC" | c_len.sh "$LEN" || echo "$DEC"

