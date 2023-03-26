. "$ZDOTDIR/interactive.zsh"
. "$ZDOTDIR/prompt.zsh"

. "$ZDOTDIR/builtin.zsh"

. "$HOME/.local/func.shell"
. "$HOME/.local/aliases.shell"

[ ! -d "$ZDOTDIR/rc.d" ] ||
for file in $(find -L "$ZDOTDIR/rc.d" -type f,l | sort)
do
    . "$file"
done

