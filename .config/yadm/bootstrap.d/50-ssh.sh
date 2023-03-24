#!/bin/sh
set -e

echo

# Set permissions
echo "Setting correct permissions on the ssh directory..."

chmod 700 -- "$HOME/.ssh"
chmod 600 -- "$HOME/.ssh/config"

echo

