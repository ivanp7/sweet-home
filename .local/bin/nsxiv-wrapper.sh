#!/bin/bash

if [ "$#" -eq 0 ]
then
    nsxiv -t .
elif [ -d "${@: -1}" ]
then
    nsxiv -t "$@"
else
    nsxiv "$@"
fi

