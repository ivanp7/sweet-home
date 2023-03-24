. "$HOME/.local/env.shell"

for file in $(find -L "$ZDOTDIR/env.d" -type f,l | sort)
do
    . "$file"
done

