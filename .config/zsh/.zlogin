[ ! -d "$ZDOTDIR/login.d" ] ||
for file in $(find -L "$ZDOTDIR/login.d" -type f,l | sort)
do
    . "$file"
done

