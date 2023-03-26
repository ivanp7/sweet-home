#!/bin/sh

for wid in $(bspc query -N -n .focused)
do
    bspc node "$wid" --flag hidden=on --flag marked=off
done

