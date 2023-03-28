. "$HOME/.local/env.xdg.shell"  # 1. define XDG paths and USER_BINARIES_PATH
. "$HOME/.local/env.path.shell" # 2. add USER_BINARIES_PATH to PATH
. "$HOME/.local/env.shell"      # 3. define other variables

[ ! -d "$ZDOTDIR/env.d" ] ||
for file in $(find -L "$ZDOTDIR/env.d" -type f,l | sort)
do
    . "$file"
done

