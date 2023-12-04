#!/bin/sh

BIN="$@"
BIN="$(echo "$BIN" | tr -d ' ')"
echo "$BIN" | grep -q "[^01]" && exit 1

echo "obase=16; ibase=2; $BIN" | bc

