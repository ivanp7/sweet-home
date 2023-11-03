[ ! -d "$ZDOTDIR/logout.d" ] ||
for file in $(find -L "$ZDOTDIR/logout.d" -type f,l | sort)
do
    . "$file"
done

