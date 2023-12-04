#!/bin/sh

OCT="$@"
OCT="$(echo "$OCT" | tr -d ' ')"
echo "$OCT" | grep -q "[^0-7]" && exit 1

DEC="$(echo "obase=10; ibase=8; $OCT" | bc)"
[ "$LEN" ] && echo "$DEC" | c_len.sh "$LEN" || echo "$DEC"

