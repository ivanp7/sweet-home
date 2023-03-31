#!/bin/sh

command -v slock > /dev/null || exit 1

lock_screen ()
{
    # switch keyboard to the default state
    xkblayout.sh

    # lock
    slock

    # slock breaks keymaps, reload them
    bspwm-autostart-script.sh "10-keymaps.sh"
}

lock_screen & "$@"

