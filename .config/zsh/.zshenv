. "$HOME/.local/env.shell"

[ ! -d "$ZDOTDIR/env.d" ] ||
for file in $(find -L "$ZDOTDIR/env.d" -type f,l | sort)
do
    . "$file"
done

