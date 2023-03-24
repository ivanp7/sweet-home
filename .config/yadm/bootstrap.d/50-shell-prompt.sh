#!/bin/sh
set -e

echo

# Install prompt
echo "Downloading prompt scripts..."
if ! {
    curl -fLo "$USER_BINARIES_PATH/prompt.py" --create-dirs \
        "https://raw.githubusercontent.com/ivanp7/prompt/master/prompt.py" &&
    curl -fLo "$USER_BINARIES_PATH/prompt.sh" --create-dirs \
        "https://raw.githubusercontent.com/ivanp7/prompt/master/prompt.sh"; }
then
    echo "Couldn't download prompt scripts"
    exit 1
fi

chmod +x "$USER_BINARIES_PATH/prompt.py" "$USER_BINARIES_PATH/prompt.sh"

echo

