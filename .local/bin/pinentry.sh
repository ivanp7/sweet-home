#!/bin/sh

TIMEOUT=300

case "$PINENTRY_USER_DATA" in
    X)      exec /usr/bin/pinentry-qt5    -o $TIMEOUT "$@" ;;
    curses) exec /usr/bin/pinentry-curses -o $TIMEOUT "$@" ;;
    *)      exec /usr/bin/pinentry-tty    -o $TIMEOUT "$@" ;;
esac

