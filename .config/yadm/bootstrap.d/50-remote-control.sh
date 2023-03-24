#!/bin/sh
set -e

echo

# Install remote control script
echo "Downloading remote control script..."
if ! curl -fLo "$USER_BINARIES_PATH/remote.py" --create-dirs \
    "https://raw.githubusercontent.com/ivanp7/remote-control/python/remote.py"
then
    echo "Couldn't download remote control script"
    exit 1
fi

chmod +x "$USER_BINARIES_PATH/remote.py"

echo

