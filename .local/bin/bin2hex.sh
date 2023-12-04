#!/bin/sh

BIN="$1"
shift 1

echo "$BIN" | grep -q "[^01]" && exit 1

echo "obase=16; ibase=2; $BIN" | bc

