#!/bin/sh
set -e

echo

PLUGINS_DIR="$XDG_CACHE_HOME/tmux/plugins"

if [ ! -d "$PLUGINS_DIR" ]
then
    # Create plugins directory
    echo "Creating plugins directory..."
    mkdir -p -- "$PLUGINS_DIR"

    # Install tpm
    echo "Cloning tmux plugin manager git repo..."
    git clone "https://github.com/tmux-plugins/tpm" "$PLUGINS_DIR/tpm"

    # Install plugins
    echo "Invoking 'install_plugins' command..."
    "$PLUGINS_DIR/tpm/bin/install_plugins"
else
    # Remove unused plugins
    echo "Invoking 'clean_plugins' command..."
    "$PLUGINS_DIR/tpm/bin/clean_plugins"

    # Update used plugins
    echo "Invoking 'update_plugins all' command..."
    "$PLUGINS_DIR/tpm/bin/update_plugins" all
fi

unset PLUGINS_DIR

echo

