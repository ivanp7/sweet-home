# functionality {{{
# aliases {{{
# cd {{{

alias d='dirs -v | head'
alias 0=':'
alias 1='cd +1'
alias 2='cd +2'
alias 3='cd +3'
alias 4='cd +4'
alias 5='cd +5'
alias 6='cd +6'
alias 7='cd +7'
alias 8='cd +8'
alias 9='cd +9'

# }}}
# functions {{{

alias sep='separator'
alias spe='spectrum'

# }}}
# }}}
# functions {{{

bd ()
{
    local Num="$1"
    [ -z "$Num" ] && { cd ..; return; }

    local Path="./"
    for i in $(seq $Num)
    do local Path="$Path/.."
    done

    cd -- "$Path"
}

bdrm ()
{
    bd "$1"
    rmdir -p -- "$(realpath -s --relative-to "$PWD" "$OLDPWD")"
}

mkcd ()
{
    local DIRS="$@"
    mkdir -p -- "$DIRS"
    cd -- "$DIRS"
}

pwdir ()
{
    printf "%q\n" "${1:-$(pwd)}"
}

his ()
{
    unset "_p_buffers[$_p_command_number]"
    unset _p_command_executed

    [ "${#_p_buffers}" -eq 0 ] && return

    for n in {1..$#_p_buffers}; do
        if [ -z "$*" ] || echo "${_p_buffers[$n]}" | grep -q "$*"
        then
            print $(_color 1)$n:${_color_reset} ${_p_buffers[$n]};
        fi
    done
}

# }}}
# }}}
# appearance {{{
# variables {{{

export _colors=$(tput colors)

export _color_reset="\033[0m"
export _color_underline="\033[4m"
export _color_no_underline="\033[24m"
export _color_strike="\033[9m"
export _color_no_strike="\033[29m"
export _color_blink="\033[5m"
export _color_no_blink="\033[25m"

# }}}
# functions {{{

_color ()
{
    if [ -n "$1" -a -z "$2" ]
    then printf "\033[38;5;${1}m"
    elif [ -n "$1" -a -n "$2" ]
    then printf "\033[38;5;${1}m\033[48;5;${2}m"
    elif [ -z "$1" -a -n "$2" ]
    then printf "\033[48;5;${2}m"
    else printf "\033[0m"
    fi
}

separator ()
{
    echo "${_color_reset}$(_color 15)$(
        dd if=/dev/zero bs=1 count=${1:-$COLUMNS} status=none | sed "s/./·/g")${_color_reset}"
}

spectrum ()
{
    # Based on: https://gist.github.com/XVilka/8346728
    # echo $COLORTERM
    awk -v term_cols="${1:-$COLUMNS}" 'BEGIN{
        s="··";
        for (colnum = 0; colnum<term_cols; colnum++) {
            r = 255-(colnum*255/term_cols);
            g = (colnum*510/term_cols);
            b = (colnum*255/term_cols);
            if (g>255) g = 510-g;
                printf "\033[48;2;%d;%d;%dm", r,g,b;
                printf "\033[38;2;%d;%d;%dm", 255-r,255-g,255-b;
                printf "%s\033[0m", substr(s,colnum%2+1,1);
            }
        printf "\n";
    }'
}

colorgrid ()
{
    local iter=0
    while [ $iter -lt 16 ]
    do
        echo -en "$(_color "" $iter) ${_color_reset}$(_color $iter)█ "
        printf "%03d" $iter

        [ $(($iter % 8)) = 7 ] && printf '\r\n' || printf ' '

        local iter=$(($iter+1))
    done

    printf '\r\n'

    local iter=16
    while [ $iter -lt 52 ]
    do
        local second=$(($iter+36))
        local third=$(($second+36))
        local fourth=$(($third+36))
        local fifth=$(($fourth+36))
        local sixth=$(($fifth+36))
        local seventh=$(($sixth+36))

        echo -en "$(_color "" $iter) ${_color_reset}$(_color $iter)█ "
        printf "%03d" $iter
        echo -en " $(_color "" $second) ${_color_reset}$(_color $second)█ "
        printf "%03d" $second
        echo -en " $(_color "" $third) ${_color_reset}$(_color $third)█ "
        printf "%03d" $third
        echo -en " $(_color "" $fourth) ${_color_reset}$(_color $fourth)█ "
        printf "%03d" $fourth
        echo -en " $(_color "" $fifth) ${_color_reset}$(_color $fifth)█ "
        printf "%03d" $fifth
        echo -en " $(_color "" $sixth) ${_color_reset}$(_color $sixth)█ "
        printf "%03d" $sixth
        if [ $seventh -lt 256 ]; then
            echo -en " $(_color "" $seventh) ${_color_reset}$(_color $seventh)█ "
            printf "%03d" $seventh
        fi

        local iter=$(($iter+1))
        printf '\r\n'
    done
}

dir_colors ()
{
    typeset -A names
    names[rs]="reset"
    names[no]="global default"
    names[fi]="normal file"
    names[di]="directory"
    names[ln]="symbolic link"
    names[mh]="multi-hardlink"
    names[pi]="named pipe"
    names[so]="socket"
    names[do]="door"
    names[bd]="block device"
    names[cd]="character device"
    names[or]="orphan symlink"
    names[mi]="missing file"
    names[su]="set uid"
    names[sg]="set gid"
    names[st]="sticky directory"
    names[tw]="sticky other writable"
    names[ow]="other writable"
    names[ca]="file with capability"
    names[ex]="executable"

    for i in ${(s.:.)LS_COLORS}
    do
        local key=${i%\=*}
        local color=${i#*\=}
        local name=${names[(e)$key]-$key}
        printf '(\e[%sm%s\e[m) ' $color $name
    done
    echo
}

# }}}
# }}}

# vim: ft=zsh: foldmethod=marker:
