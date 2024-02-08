#!/bin/sh

exec sbcl --load "${XDG_CACHE_HOME:-"$HOME/.cache"}/nvim/plugged/vlime/lisp/start-vlime.lisp"

