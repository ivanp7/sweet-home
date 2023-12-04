#!/bin/sh

LENGTH="$1"
shift 1

NUMBER="$(cat)"

if [ "$LENGTH" -ge "${#NUMBER}" ]
then
    dd if=/dev/zero bs=1 count=$(($LENGTH - ${#NUMBER})) 2> /dev/null | sed "s/./0/g"
    echo "$NUMBER"
else
    echo "#"
    exit 1
fi

