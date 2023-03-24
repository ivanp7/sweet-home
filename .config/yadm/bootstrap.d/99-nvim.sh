#!/bin/sh
set -e

# This script must be called last, as it breaks the 'find | while' loop in the bootstrap script!

echo

# Install plug.vim
echo "Downloading vim-plug..."
# if ! curl -fLo "$XDG_DATA_HOME/nvim/site/autoload/plug.vim" --create-dirs \
#     "https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim"
# then
#     echo "Couldn't download vim-plug"
#     exit 1
# fi
echo

# Install/update plugins
echo "Invoking :PlugUpdate command..."
nvim -es -u "$XDG_CONFIG_HOME/nvim/init.vim" -i NONE -c "PlugUpdate" -c "qa"

# # Remove possible leftovers
echo "Invoking :PlugClean! command..."
nvim -es -u "$XDG_CONFIG_HOME/nvim/init.vim" -i NONE -c "PlugClean!" -c "qa"

# Create directories
echo "Creating backup directory..."
mkdir -p -- "$XDG_DATA_HOME/nvim/backup"

echo

