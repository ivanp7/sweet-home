#!/bin/sh
set -e

PATTERN="$1"
REPLACEMENT="$2"
shift 2

: ${SEP:="/"}

FILES="$(rg "$@" -l -e "$PATTERN")"
echo "$FILES"
echo "$FILES" | xargs -rd'\n' sed -i -e "s${SEP}${PATTERN}${SEP}${REPLACEMENT}${SEP}g"

