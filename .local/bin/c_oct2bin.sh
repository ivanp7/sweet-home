#!/bin/sh

OCT="$@"
OCT="$(echo "$OCT" | tr -d ' ')"
echo "$OCT" | grep -q "[^0-7]" && exit 1

BIN="$(echo "obase=2; ibase=8; $OCT" | bc)"
[ "$LEN" ] && echo "$BIN" | c_len.sh "$LEN" || echo "$BIN"

