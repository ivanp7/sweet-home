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

if [ -z "$1" ]
then
    SED_PATTERN='/^ M /!d; s/^ M //'
    GITDIFF_FLAGS=''
else
    SED_PATTERN='/^M  /!d; s/^M  //'
    GITDIFF_FLAGS='--cached'
fi

git status -s . 2> /dev/null | sed "$SED_PATTERN" |
while IFS="
" read -r file
do
    mkdir -p -- "$DIR/$(dirname -- "$file")"
    git diff $GITDIFF_FLAGS -- "$file" > "$DIR/$file.diff"
done

if ! rmdir -- "$DIR" 2> /dev/null
then
    cd -- "$DIR"
    IFS="
" ${EDITOR:-vi} -R -- $(find . -type f)
fi

clean_exit

