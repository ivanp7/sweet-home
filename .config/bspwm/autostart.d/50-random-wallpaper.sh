#!/bin/sh

if [ -d "$WALLPAPERS_DIR" ]
then
    cd -- "$WALLPAPERS_DIR"

    exec xwallpaper.sh "$(find -L . -path "./.git" -prune -o -type f,l |
        while IFS="
" read -r file
        do
            file --mime-type -bLE -- "$file" | grep -qv "^image/" || echo "$file"
        done | shuf -n 1)"
fi

