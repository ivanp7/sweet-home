#!/bin/sh

DMENU_PROMPT="Password"
: ${DMENU_LINES:=20}
: ${DMENU_COLUMNS:=2}

: ${NOTIFY_TIME:=3000}

cd -- "$PASSWORD_STORE_DIR"

export PINENTRY_USER_DATA=X

NAME="$(find . -path "./.git" -prune -o -type f -name "*.gpg" -print | sed 's|^\./||; s|\.gpg$||' |
    dmenu.sh -p "$DMENU_PROMPT" -l "$DMENU_LINES" -g "$DMENU_COLUMNS" | head -1)"

[ -z "$NAME" ] || { pass -c "$NAME" > /dev/null &&
    notify-send -t "$NOTIFY_TIME" -u normal -- "pass-dmenu.sh" "$NAME"; }

