#!/bin/sh

desktop_name ()
{
    case "$1" in
        1) echo "${DESKTOP_1:-"I"}" ;;
        2) echo "${DESKTOP_2:-"II"}" ;;
        3) echo "${DESKTOP_3:-"III"}" ;;
        4) echo "${DESKTOP_4:-"IV"}" ;;
        5) echo "${DESKTOP_5:-"V"}" ;;
        6) echo "${DESKTOP_6:-"VI"}" ;;
        7) echo "${DESKTOP_7:-"VII"}" ;;
        8) echo "${DESKTOP_8:-"VIII"}" ;;
        9) echo "${DESKTOP_9:-"IX"}" ;;
        10) echo "${DESKTOP_10:-"X"}" ;;
    esac
}

MONITOR="$2"

N="$(bspc query -D -m $MONITOR | wc -l)"

add_desktop ()
{
    [ "$N" -lt 10 ] || return
    bspc monitor "$MONITOR" -a "$(desktop_name $(($N + 1)))" && N=$((N + 1))
}

del_desktop ()
{
    [ "$N" -gt 1 ] || return
    local desktop_id="$(bspc query -m "$MONITOR" -D | tail -1)"
    bspc desktop "$desktop_id" -r && N=$(($N - 1))
}

case "$1" in
    "") echo "$N" ;;
    inc) add_desktop ;;
    dec) del_desktop ;;
    *)
        delta=$(("$1" - $N))
        if [ "$delta" -gt 0 ]
        then
            for i in $(seq $delta); do add_desktop || exit 1; done
        elif [ "$delta" -lt 0 ]
        then
            for i in $(seq $delta -1); do del_desktop || exit 1; done
        fi
esac

