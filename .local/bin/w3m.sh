#!/bin/sh

mkdir -p -- "$XDG_DATA_HOME/w3m"
HOME="$XDG_DATA_HOME/w3m" exec w3m -config "$XDG_CONFIG_HOME/w3m/config" "$@"

