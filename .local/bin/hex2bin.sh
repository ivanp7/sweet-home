#!/bin/sh

HEX="$@"
HEX="$(echo "$HEX" | tr -d ' ' | tr 'abcdef' 'ABCDEF')"
echo "$HEX" | grep -q "[^A-F0-9]" && exit 1

echo "obase=2; ibase=16; $HEX" | bc

