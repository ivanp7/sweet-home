#!/bin/sh

HEX="$@"
HEX="$(echo "$HEX" | tr -d ' ' | tr 'abcdef' 'ABCDEF')"
echo "$HEX" | grep -q "[^A-F0-9]" && exit 1

OCT="$(echo "obase=8; ibase=16; $HEX" | bc)"
[ "$LEN" ] && echo "$OCT" | c_len.sh "$LEN" || echo "$OCT"

