#!/bin/sh

[ -z "${YADM_BRANCH:-}" ] && exec yadm "$@" ||
    exec yadm --yadm-bootstrap "${XDG_CONFIG_HOME:-"$HOME/.config"}/bootstrap" --yadm-dir "${XDG_CONFIG_HOME:-"$HOME/.config"}/yadm/branch/$YADM_BRANCH" --yadm-data "${XDG_DATA_HOME:-"$HOME/.local/share"}/yadm/branch/$YADM_BRANCH" "$@"

