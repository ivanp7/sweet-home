#!/bin/sh

command -v pactl > /dev/null || exit

SHORT_NAME_LENGTH=20

SINK=$(pactl info | grep "^Default Sink: " | sed 's/[^:]*: //')

print_sink_state ()
{
    SINK_INFO=$(pactl list sinks | grep -A 11 "^Sink #$1$")

    SINK_NAME=$(echo "$SINK_INFO" | grep "^\s*Name: ")
    SINK_NAME_SHORT=$(echo "$SINK_NAME" | sed 's/[^:]*: //; s/^[^.]*\.//; s/\.[^.]*$//' | head -c $SHORT_NAME_LENGTH)

    SINK_STATUS=$(echo "$SINK_NAME" | grep -F "$SINK")
    [ -z "$SINK_STATUS" ] || SINK_STATUS="<<<<<<"

    SINK_MUTE=$(echo "$SINK_INFO" | grep "^\s*Mute: " | sed 's/[^:]*: //')
    case "$SINK_MUTE" in
        no) STATE="on" ;;
        yes) STATE="off" ;;
    esac

    SINK_VOLUME=$(echo "$SINK_INFO" | grep "^\s*Volume: " | sed 's/[^:]*: //')
    SINK_VOLUME_FRONT_LEFT=$(echo "$SINK_VOLUME" | sed -E 's/.*front-left:[^:]*\/\s*([0-9]*)%\s*\/.*/\1/')
    SINK_VOLUME_FRONT_RIGHT=$(echo "$SINK_VOLUME" | sed -E 's/.*front-right:[^:]*\/\s*([0-9]*)%\s*\/.*/\1/')

    [ "$SINK_VOLUME_FRONT_LEFT" = "$SINK_VOLUME_FRONT_RIGHT" ] &&
        LEVEL="$SINK_VOLUME_FRONT_LEFT" ||
        LEVEL="$SINK_VOLUME_FRONT_LEFT/$SINK_VOLUME_FRONT_RIGHT"

    echo "$SINK_NAME_SHORT: [$LEVEL% $STATE] $SINK_STATUS"
}

cycle_default_sink ()
{
    GREP_FLAG=$1
    LOCAL_PROG=$2
    OTHER_END_PROG=$3

    NEIGHBOUR_SINKS=$(pactl list short sinks | grep -F $GREP_FLAG 1 "$SINK")
    NEIGHBOUR_SINKS_COUNT=$(echo "$NEIGHBOUR_SINKS" | wc -l)

    if [ "$NEIGHBOUR_SINKS_COUNT" -eq 2 ]
    then
        pactl set-default-sink $(echo "$NEIGHBOUR_SINKS" | $LOCAL_PROG -1 | sed 's/\s.*//')
    elif [ "$NEIGHBOUR_SINKS_COUNT" -eq 1 ]
    then
        pactl set-default-sink $(pactl list short sinks | $OTHER_END_PROG -1 | sed 's/\s.*//')
    fi
}

case $1 in
    "")
        SINKS=$(pactl list short sinks | sed 's/\s.*//')
        for s in $SINKS
        do print_sink_state $s
        done
        ;;

    prev) cycle_default_sink -B head tail ;;
    next) cycle_default_sink -A tail head ;;

    toggle) pactl set-sink-mute $SINK toggle ;;
    up) pactl set-sink-volume $SINK +3% ;;
    down) pactl set-sink-volume $SINK -3% ;;
    *) pactl set-sink-volume $SINK $1% ;;
esac

