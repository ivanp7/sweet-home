#!/bin/sh
set -e

PLUGINS_DIR="$XDG_CACHE_HOME/tmux/plugins"

if [ ! -d "$PLUGINS_DIR" ]
then
    # Create plugins directory
    mkdir -p -- "$PLUGINS_DIR"

    # Install tpm
    git clone "https://github.com/tmux-plugins/tpm" "$PLUGINS_DIR/tpm"

    # Install plugins
    "$PLUGINS_DIR/tpm/bin/install_plugins"
else
    # Remove unused plugins
    "$PLUGINS_DIR/tpm/bin/clean_plugins"

    # Update used plugins
    "$PLUGINS_DIR/tpm/bin/update_plugins" all
fi

unset PLUGINS_DIR

