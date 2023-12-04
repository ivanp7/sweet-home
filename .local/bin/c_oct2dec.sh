#!/bin/sh

OCT="$@"
OCT="$(echo "$OCT" | tr -d ' ')"
echo "$OCT" | grep -q "[^0-7]" && exit 1

echo "obase=10; ibase=8; $OCT" | bc

