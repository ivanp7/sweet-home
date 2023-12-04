#!/bin/sh

OCT="$@"
OCT="$(echo "$OCT" | tr -d ' ')"
echo "$OCT" | grep -q "[^0-7]" && exit 1

HEX="$(echo "obase=16; ibase=8; $OCT" | bc)"
[ "$LEN" ] && echo "$HEX" | c_len.sh "$LEN" || echo "$HEX"

