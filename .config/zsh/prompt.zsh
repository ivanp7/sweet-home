: ${_p_command_number:=1}

: ${_p_prompt_py:="prompt.py"}
: ${_p_prompt_sh:="prompt.sh"}

# auxiliary functions {{{
# shell activity flag {{{

_p_is_shell_inactive ()
{
    [ ! -f "$TMPDIR_SESSION/active_shell/$$" ]
}

_p_set_active_shell_flag ()
{
    mkdir -p -- "$TMPDIR_SESSION/active_shell"
    touch -- "$TMPDIR_SESSION/active_shell/$$"
}

_p_unset_active_shell_flag ()
{
    _p_is_shell_inactive || rm -- "$TMPDIR_SESSION/active_shell/$$"
}

_p_parent_shell_pid=${_p_parent_shell_pid_exported:-}
export _p_parent_shell_pid_exported=$$

[ ! -f "$TMPDIR_SESSION/active_shell/$_p_parent_shell_pid" ] || rm -- "$TMPDIR_SESSION/active_shell/$_p_parent_shell_pid"

# }}}
# cursor & right prompt {{{

_p_set_cursor_shape ()
{
    case $1 in
        block) echo -ne '\e[2 q' ;;
        underline) echo -ne '\e[4 q' ;;
        bar) echo -ne '\e[6 q' ;;
    esac
}

_p_set_insert_prompt ()
{
    RPROMPT="$(PROMPT_ESC="zsh" "$_p_prompt_py" right_prompt "$_p_command_number")"
    RPS2="$RPROMPT"
    _p_set_cursor_shape bar
}

_p_set_vicommand_prompt ()
{
    RPROMPT="%S [vi] %s"
    RPS2="$RPROMPT"
    _p_set_cursor_shape block
}

_p_set_abandoned_prompt ()
{
    RPROMPT=""
    RPS2=""
    _p_set_cursor_shape block
}

# }}}
# }}}
# hooks {{{

_p_preexec ()
{
    unset _p_in_prompt

    _p_timer=$SECONDS
    _p_need_cmd_result_processing="true"

    echo "${_color_reset}"
}
add-zsh-hook preexec _p_preexec

_p_prompt_set_env_f ()
{
    _p_exit_code="$?" # This must be the first

    _p_in_prompt="true"

    if [ "$_p_need_cmd_result_processing" ]
    then
        unset _p_need_cmd_result_processing

        _p_command_number=$(($_p_command_number + 1))

        if [ "$_p_timer" ]
        then
            _p_exec_time=$(($SECONDS - $_p_timer))
            unset _p_timer

            [ "$_p_exec_time" -lt 0 ] && unset _p_exec_time
        fi
    else
        unset _p_exit_code
        unset _p_exec_time
    fi
}
add-zsh-hook precmd _p_prompt_set_env_f

_p_prompt_init_f ()
{
    _p_set_insert_prompt
}
add-zsh-hook precmd _p_prompt_init_f

# }}}
# ZLE widgets {{{

zle-keymap-select ()
{
    [ "$KEYMAP" = "vicmd" ] && _p_set_vicommand_prompt || _p_set_insert_prompt
    zle reset-prompt
}
zle -N zle-keymap-select

zle-line-init ()
{
    (( ${+terminfo[smkx]} )) && echoti smkx

    _p_set_insert_prompt
    zle reset-prompt
}
zle -N zle-line-init

zle-line-finish ()
{
    (( ${+terminfo[rmkx]} )) && echoti rmkx

    _p_buffers[$_p_command_number]="$BUFFER"

    _p_set_abandoned_prompt
    zle reset-prompt
}
zle -N zle-line-finish

# }}}
# traps {{{

_p_exit_trap ()
{
    [ -z "$_p_in_prompt" ] || _p_set_abandoned_prompt
    _p_unset_active_shell_flag

    clean_exit $1
}
trap '_p_exit_trap $?' EXIT ${=TRAPPED_SIGNALS}

TRAPINT ()
{
    # Fix a bug when you C-c in CMD mode and you'd be prompted with CMD mode indicator,
    # while in fact you would be in INS mode
    # Fixed by catching SIGINT (C-c), set vim_mode to INS and then repropagate the SIGINT,
    # so if anything else depends on it, we will not break it
    _p_set_abandoned_prompt
    zle && { zle reset-prompt; zle -R; }

    return $((128 + $1))
}

# }}}

_p_prompt ()
{
    if _p_is_shell_inactive
    then
        _p_set_active_shell_flag

        printf "$_p_color_reset$(_color 15)\n"
        separator
        session-info.sh
    fi

    echo "$_p_color_reset"

    [ -z "$_p_exit_code" ] || { "$_p_prompt_py" cmd_result $_p_exit_code $_p_exec_time; echo; }
    "$_p_prompt_sh" ; echo

    PROMPT="$(PROMPT_ESC="zsh" PROMPT_ROOT="$([ "$(id -u)" = "0" ] && echo "y")" "$_p_prompt_py" left_prompt "${USER}@${HOST}")"
    PROMPT2=""
    _p_set_insert_prompt
}
add-zsh-hook precmd _p_prompt

# vim: ft=zsh: foldmethod=marker:
