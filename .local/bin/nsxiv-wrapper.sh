#!/bin/bash

if [ "$1" = "-e" ]
then
    WID="$2"
    shift 2

    NSXIV_ARGS="-e $WID ${NSXIV_ARGS:-}"
fi

if [ "$#" -eq 0 ]
then
    nsxiv ${NSXIV_ARGS:-} -t .
elif [ -d "${@: -1}" ]
then
    nsxiv ${NSXIV_ARGS:-} -t "$@"
else
    nsxiv ${NSXIV_ARGS:-} "$@"
fi

