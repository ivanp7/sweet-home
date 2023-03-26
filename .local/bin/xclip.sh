#!/bin/sh

exec xclip -selection clipboard ${1:+-t $1}

