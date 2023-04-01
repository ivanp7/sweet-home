#!/bin/sh

exec sdcv --utf8-input --utf8-output --color "$@" | sed 's/\([[:digit:]]\+)\)/\n\n\1/g; s/;/;\n/g; s/<br>/\n/g'

