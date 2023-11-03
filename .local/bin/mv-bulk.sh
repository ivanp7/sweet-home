#!/bin/sh
set -u

: ${EDITOR:=vi}

original_names_file="$(mktemp -p "$TMPDIR_SESSION" bulk_mv_original_names.XXXXXX)"
changed_names_file="$(mktemp -p "$TMPDIR_SESSION" bulk_mv_changed_names.XXXXXX)"
commands_file="$(mktemp -p "$TMPDIR_SESSION" bulk_mv_commands.XXXXXX)"

clean_exit ()
{
    rm -f -- "$original_names_file" "$changed_names_file" "$commands_file"
    exit $1
}
[ -z "${TRAPPED_SIGNALS:-}" ] || trap 'clean_exit $?' $TRAPPED_SIGNALS

for file in "$@"
do
    FILE="$(/usr/bin/printf "%q\n" "$file")"
    echo "$FILE" >> "$original_names_file"
    echo "$FILE" >> "$changed_names_file"
done

"$EDITOR" -- "$changed_names_file"

if [ "$(wc -l < "$original_names_file")" -eq "$(wc -l < "$changed_names_file")" ]
then
    paste -d" " "$original_names_file" "$changed_names_file" > "$commands_file"
    sed -i 's/^/mv -vi -- /' "$commands_file"

    "$EDITOR" -- "$commands_file"
    sh < "$commands_file"
    clean_exit $?
else
    echo "Error: number of lines is not equal to the number of files."
    clean_exit 1
fi

