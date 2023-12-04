#!/bin/sh

DEC="$@"
DEC="$(echo "$DEC" | tr -d ' ')"
echo "$DEC" | grep -q "[^0-9]" && exit 1

OCT="$(echo "obase=8; ibase=10; $DEC" | bc)"
[ "$LEN" ] && echo "$OCT" | c_len.sh "$LEN" || echo "$OCT"

