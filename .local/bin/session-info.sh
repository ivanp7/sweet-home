#!/bin/sh
set -u

NumberOfColors=$(tput colors)

ColorReset="\033[0m"
_color ()
{
    if [ -n "${1:-}" -a -z "${2:-}" ]
    then printf "\033[38;5;${1}m"
    elif [ -n "${1:-}" -a -n "${2:-}" ]
    then printf "\033[38;5;${1}m\033[48;5;${2}m"
    elif [ -z "${1:-}" -a -n "${2:-}" ]
    then printf "\033[48;5;${2}m"
    else printf "\033[0m"
    fi
}

userhost ()
{
    ColorUnderline="\033[4m"
    ColorNoUnderline="\033[24m"

    local UserColor="$(_color 15)${ColorUnderline}"
    [ "$(id -u)" -eq 0 ] && UserColor="$(_color 196)${ColorUnderline}"
    local AtColor="${ColorNoUnderline}$(_color 244)"
    local HostColor="$(_color 15)${ColorUnderline}"

    echo "${ColorReset}${1:-}${UserColor}$(id -un)${AtColor}@${HostColor}$(cat /etc/hostname)${ColorReset}"
}

process_chain ()
{
    local ArrowColor="${ColorReset}$(_color 244)"
    local Arrow=" → "

    if [ "$NumberOfColors" -ge 256 ]
    then
        local ProcColor="$(_color 15 240)"
    else
        local ProcColor="$(_color 0 15)"
    fi

    local ParentPID="$PPID"
    local PSTree="$(exec pstree -ls "$ParentPID")"
    local PSTree="$(echo "$PSTree" | head -1 |
        sed -E "s/-(-|[+])-/---/g; s/^---//; s/---pstree$//; s/---/\n/g" | head -n -2)"

    echo "$PSTree" | head -n -1 |
        while IFS="
" read -r proc
    do
        printf "${ProcColor} $proc ${ArrowColor}${Arrow}"
    done

    echo "${ProcColor} $(echo "$PSTree" | tail -n -1) ${ColorReset}"
}

shell_cmd ()
{
    ps -p "$PPID" -o exe --no-headers
}

session_info ()
{
    local TextColor="$(_color 244)"
    local ValueColor="$(_color 15)"

    echo "${TextColor}current date/time: ${ValueColor}$(date +'%Y-%b-%d %a %H:%M:%S')${ColorReset}"
    echo "${TextColor}tty: ${ValueColor}$(tty)${TextColor}, X display: ${ValueColor}${DISPLAY:-none}${ColorReset}"
    echo "${TextColor}terminal: ${ValueColor}$TERM${TextColor}, ${ValueColor}${NumberOfColors}${TextColor} colors, ${ValueColor}$(tput cols)${TextColor}x${ValueColor}$(tput lines)${TextColor} cells${ColorReset}"
    echo "${TextColor}process chain: $(process_chain)${ColorReset}"
    echo "${TextColor}running ${ValueColor}$(shell_cmd)${TextColor} as $(userhost)${ColorReset}"
}

session_info

