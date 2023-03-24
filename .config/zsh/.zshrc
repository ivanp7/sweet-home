[ "$NON_INTERACTIVE" ] || . "$ZDOTDIR/interactive.zsh"
. "$ZDOTDIR/builtin.zsh"
. "$ZDOTDIR/prompt.zsh"

[ ! -d "$ZDOTDIR/rc.d" ] ||
for file in $(find -L "$ZDOTDIR/rc.d" -type f,l | sort)
do
    . "$file"
done

