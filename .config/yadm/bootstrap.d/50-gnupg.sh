#!/bin/sh
set -e

echo

# Set permissions
echo "Setting correct permissions on the gnupg directory..."

chmod 700 -- "$GNUPGHOME/"
chmod 600 -- "$GNUPGHOME/gpg.conf"
chmod 600 -- "$GNUPGHOME/gpg-agent.conf"

echo

