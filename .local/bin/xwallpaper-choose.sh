#!/bin/sh

# take random picture from selected range
if [ -d "$WALLPAPERS_DIR" ]
then
    cd -- "$WALLPAPERS_DIR"

    exec xwallpaper.sh "$(find -L . -path "./.git" -prune -o -type f,l |
        while IFS="
" read -r file
        do
            file --mime-type -bLE "$file" | grep -q "^image/" && echo "$file"
        done | nsxiv -tio | shuf -n 1)"
fi

