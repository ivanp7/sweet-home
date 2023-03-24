#!/bin/sh
set -e

# Install plug.vim
curl -fLo "$XDG_DATA_HOME/nvim/site/autoload/plug.vim" --create-dirs \
    "https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim"

# Install/update plugins
nvim -es -u "$XDG_CONFIG_HOME/nvim/init.vim" -i NONE -c "PlugUpdate" -c "qa"

# Remove possible leftovers
nvim -es -u "$XDG_CONFIG_HOME/nvim/init.vim" -i NONE -c "PlugClean!" -c "qa"

# Create directories
mkdir -p -- "$XDG_DATA_HOME/nvim/backup"

