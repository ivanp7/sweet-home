#!/bin/sh

EXECUTABLE="$1"
[ -r "$EXECUTABLE" ] || exit 127
shift 1

MKTEMP_PATTERN="edex.$(basename -- "$EXECUTABLE").XXX"
EDITED_EXECUTABLE="$(mktemp -p "$(dirname -- "$EXECUTABLE")" ".$MKTEMP_PATTERN~")" ||
    EDITED_EXECUTABLE="$(mktemp -p "${TMPDIR:-/tmp}" "$MKTEMP_PATTERN")" || exit 126

clean_exit ()
{
    rm -- "$EDITED_EXECUTABLE"
    exit $1
}
[ -z "${TRAPPED_SIGNALS:-}" ] || trap 'clean_exit $?' $TRAPPED_SIGNALS

chmod 700 -- "$EDITED_EXECUTABLE" || clean_exit 126
cat -- "$EXECUTABLE" > "$EDITED_EXECUTABLE" || clean_exit 127

"${EDITOR:-vi}" -- "$EDITED_EXECUTABLE"
[ -s "$EDITED_EXECUTABLE" ] || { echo "[edex] edited executable is empty" >&2; clean_exit 0; }

"$EDITED_EXECUTABLE" "$@"
clean_exit $?

