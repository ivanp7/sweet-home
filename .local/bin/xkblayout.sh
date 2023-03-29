#!/bin/sh

LINE_NO=$(xkblayout-state print "%S" | grep -Fxn "${1:-"us"}" | cut -d ':' -f 1)
[ "$LINE_NO" ] && xkblayout-state set $(($LINE_NO - 1))

