#!/bin/sh

DMENU_PROMPT="Word"
: ${DMENU_LINES:=20}
: ${DMENU_COLUMNS:=10}

HISTORY_FILE="$SDCV_HISTFILE"
touch -- "$HISTORY_FILE"

INPUT=$(tac -- "$HISTORY_FILE" | uniq | dmenu -p "$DMENU_PROMPT" -l "$DMENU_LINES" -g "$DMENU_COLUMNS" | head -1)
[ "$INPUT" ] || exit

SCRATCHPAD="${SCRATCHPAD_DICT:-0}" scratchpad-st.sh -t "$(echo "$INPUT - sdcv" | sed "
s/А/A/g;   s/а/a/g;
s/Б/B/g;   s/б/b/g;
s/В/V/g;   s/в/v/g;
s/Г/G/g;   s/г/g/g;
s/Д/D/g;   s/д/d/g;
s/Е/Je/g;  s/е/je/g;
s/Ё/Jo/g;  s/ё/jo/g;
s/Ж/Zh/g;  s/ж/zh/g;
s/З/Z/g;   s/з/z/g;
s/И/I/g;   s/и/i/g;
s/Й/J/g;   s/й/j/g;
s/К/K/g;   s/к/k/g;
s/Л/L/g;   s/л/l/g;
s/М/M/g;   s/м/m/g;
s/Н/N/g;   s/н/n/g;
s/О/O/g;   s/о/o/g;
s/П/P/g;   s/п/p/g;
s/Р/R/g;   s/р/r/g;
s/С/S/g;   s/с/s/g;
s/Т/T/g;   s/т/t/g;
s/У/U/g;   s/у/u/g;
s/Ф/F/g;   s/ф/f/g;
s/Х/H/g;   s/х/h/g;
s/Ц/Ts/g;  s/ц/ts/g;
s/Ч/Ch/g;  s/ч/ch/g;
s/Ш/Sh/g;  s/ш/sh/g;
s/Щ/Sch/g; s/щ/sch/g;
s/Ъ/'/g;   s/ъ/'/g;
s/Ы/Y/g;   s/ы/y/g;
s/Ь/'/g;   s/ь/'/g;
s/Э/E/g;   s/э/e/g;
s/Ю/Ju/g;  s/ю/ju/g;
s/Я/Ja/g;  s/я/ja/g;
")" -e sh -c "sleep 0.1; dict.sh -n '$INPUT' | less -mr"

