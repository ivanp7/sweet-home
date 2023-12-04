#!/bin/sh

HEX="$1"
shift 1

echo "$HEX" | grep -q "[^A-Fa-f0-9]" && exit 1

HEX="$(echo "$HEX" | tr 'abcdef' 'ABCDEF')"
echo "obase=2; ibase=16; $HEX" | bc

