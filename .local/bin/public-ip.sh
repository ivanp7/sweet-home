#!/bin/sh

curl ifconfig.me 2> /dev/null | grep -x "[0-9]\+\.[0-9]\+\.[0-9]\+\.[0-9]\+"

