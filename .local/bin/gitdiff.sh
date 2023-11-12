#!/bin/sh
set -e

DIR="$(mktemp -d -p "$TMPDIR" "gitdiff.XXXX")"

clean_exit ()
{
    [ ! -d "$DIR" ] || rm -rf -- "$DIR"
    trap - EXIT
    exit $1
}
trap 'clean_exit $?' EXIT $TRAPPED_SIGNALS

git status -s . 2> /dev/null | sed '/^\s*M\s*/!d; s/^\s*M\s*//' |
while IFS="
" read -r file
do
    mkdir -p -- "$DIR/$(dirname -- "$file")"
    git diff -- "$file" > "$DIR/$file.diff"
done

if ! rmdir -- "$DIR" 2> /dev/null
then
    cd -- "$DIR"
    IFS="
" ${EDITOR:-vi} -R -- $(find . -type f)
fi

clean_exit

