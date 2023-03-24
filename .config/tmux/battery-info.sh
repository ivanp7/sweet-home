#!/bin/sh

acpi -b 2> /dev/null | sed '
s/Discharging/↓/; s/Charging/↑/;
s/[A-Za-z,]*//g; s/\s\+/ /g; s/^\s\+//; s/\s*$//;
s/\([0-9][0-9]:[0-9][0-9]:[0-9][0-9]\)/(\1)/;
s/^/ bat/; s/$/ /' | paste -sd'|'

