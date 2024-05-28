#!/bin/sh
set -u

PROMPT_PY="$(realpath -- "$(dirname -- "$0")/prompt.py")"
[ -x "$PROMPT_PY" ] || PROMPT_PY="prompt.py"

PROMPT_PATH="${1:-"$PWD"}"
[ -d "$PROMPT_PATH" ] || exit 1
PROMPT_PATH="$(realpath -L -- "$PROMPT_PATH")"

PROMPT_HIGHLIGHT_DEPTH=0

PROMPT_PATH_PERMS=
[ ! -r "$PROMPT_PATH" ] && PROMPT_PATH_PERMS="${PROMPT_PATH_PERMS}r"
[ ! -w "$PROMPT_PATH" ] && PROMPT_PATH_PERMS="${PROMPT_PATH_PERMS}w"
[ ! -x "$PROMPT_PATH" ] && PROMPT_PATH_PERMS="${PROMPT_PATH_PERMS}x"
[ -g "$PROMPT_PATH" ] && PROMPT_PATH_PERMS="${PROMPT_PATH_PERMS}S"
[ -k "$PROMPT_PATH" ] && PROMPT_PATH_PERMS="${PROMPT_PATH_PERMS}t"

PROMPT_GIT_HEAD=
PROMPT_GIT_HEAD_DETACHED=
PROMPT_GIT_AHEAD=
PROMPT_GIT_BEHIND=
PROMPT_GIT_MERGING=
PROMPT_GIT_UNTRACKED=
PROMPT_GIT_MODIFIED=
PROMPT_GIT_STAGED=

if [ -x "$PROMPT_PATH" ]
then
    cd -- "$PROMPT_PATH"

    if git rev-parse --is-inside-work-tree > /dev/null 2>&1 &&
        [ "$(git rev-parse --is-inside-git-dir 2> /dev/null)" = "false" ]
    then
        PROMPT_GIT_HEAD="$(git branch --show-current)"
        if [ "$PROMPT_GIT_HEAD" ]
        then
            PROMPT_GIT_HEAD_DETACHED=
        else
            PROMPT_GIT_HEAD="$(git rev-parse --short HEAD)"
            PROMPT_GIT_HEAD_DETACHED="detached"
        fi

        GIT_ROOT="$(git rev-parse --show-toplevel 2> /dev/null)"
        GIT_RELPATH="$(realpath --relative-base="$GIT_ROOT" -- "$PWD")"
        if [ "$GIT_RELPATH" = "." ]
        then
            PROMPT_HIGHLIGHT_DEPTH=1
        else
            PROMPT_HIGHLIGHT_DEPTH=$((2 + $(printf "$GIT_RELPATH" | sed 's|[^/]||g' | wc -m)))
        fi

        PROMPT_GIT_AHEAD="$(git log --oneline @{u}.. 2> /dev/null | wc -l | tr -d ' ')"
        PROMPT_GIT_BEHIND="$(git log --oneline ..@{u} 2> /dev/null | wc -l | tr -d ' ')"

        GIT_DIR="$(git rev-parse --git-dir 2> /dev/null)"
        [ -n "$GIT_DIR" -a -r "$GIT_DIR/MERGE_HEAD" ] &&
            PROMPT_GIT_MERGING="true"

        [ "$(git ls-files "$GIT_ROOT" --others --exclude-standard 2> /dev/null)" ] &&
            PROMPT_GIT_UNTRACKED="true"

        git diff --quiet 2> /dev/null || PROMPT_GIT_MODIFIED="true"
        git diff --cached --quiet 2> /dev/null || PROMPT_GIT_STAGED="true"
    fi
fi

"$PROMPT_PY" pwd "$PROMPT_PATH" "$PROMPT_HIGHLIGHT_DEPTH" "$PROMPT_PATH_PERMS" \
    "$PROMPT_GIT_HEAD" "$PROMPT_GIT_HEAD_DETACHED" \
    "$PROMPT_GIT_AHEAD" "$PROMPT_GIT_BEHIND" "$PROMPT_GIT_MERGING" \
    "$PROMPT_GIT_UNTRACKED" "$PROMPT_GIT_MODIFIED" "$PROMPT_GIT_STAGED"

