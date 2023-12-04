#!/bin/sh

DEC="$@"
DEC="$(echo "$DEC" | tr -d ' ')"
echo "$DEC" | grep -q "[^0-9]" && exit 1

echo "obase=16; ibase=10; $DEC" | bc

