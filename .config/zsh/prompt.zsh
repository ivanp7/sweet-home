PARENT_SHELL_PID=${PARENT_SHELL_PID_EXPORTED:-}
export PARENT_SHELL_PID_EXPORTED=$$

[ "$(id -u)" -eq 0 ] && export PROMPT_ROOT= || unset PROMPT_ROOT
: ${_p_command_number:=1}

_p_preexec ()
{
    unset _p_in_prompt

    _p_timer=$SECONDS
    _p_command_executed=true

    _p_prompt_postcommand_preexec
}
add-zsh-hook preexec _p_preexec

_p_prompt_set_env_f ()
{
    export PROMPT_EXIT_CODE="$?" # This needs to be first

    _p_in_prompt=true

    if [ "$_p_command_executed" ]
    then
        unset _p_command_executed

        _p_command_number=$(($_p_command_number + 1))

        if [ "$_p_timer" ]
        then
            export PROMPT_EXEC_TIME=$(($SECONDS - $_p_timer))
            unset _p_timer

            [ "$PROMPT_EXEC_TIME" -lt 0 ] && unset PROMPT_EXEC_TIME
        fi
    else
        unset PROMPT_EXIT_CODE
        unset PROMPT_EXEC_TIME
    fi

    export PROMPT_STATUS="${SSH_TTY:+"${HOST}·"}$_p_command_number${STATUS:+"·"}${STATUS:-}"

    unset PROMPT_PATH
}
add-zsh-hook precmd _p_prompt_set_env_f

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
    RPROMPT=""
    _p_set_cursor_shape bar
}

_p_set_vicommand_prompt ()
{
    RPROMPT="%{$(_color 0 15)%} vi %{$(echo "${_color_reset}")%}"
    _p_set_cursor_shape block
}

_p_set_abandoned_prompt ()
{
    RPROMPT=""
    _p_set_cursor_shape block
}

_p_prompt_init_f ()
{
    _p_set_insert_prompt
}
add-zsh-hook precmd _p_prompt_init_f

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

_p_prompt_postcommand_preexec ()
{
    echo "${_color_reset}"
}

# Fix a bug when you C-c in CMD mode and you'd be prompted with CMD mode indicator, while in fact you would be in INS mode
# Fixed by catching SIGINT (C-c), set vim_mode to INS and then repropagate the SIGINT, so if anything else depends on it, we will not break it
TRAPINT ()
{
    _p_set_abandoned_prompt
    zle && { zle reset-prompt; zle -R; }
    return $(( 128 + $1 ))
}

_p_trap_exit ()
{
    [ "$_p_in_prompt" ] && _p_set_abandoned_prompt
}
trap '_p_trap_exit' EXIT

# shell activity {{{

mkdir -p -- "$TMPDIR_SESSION/active_shells"

_p_is_shell_inactive ()
{
    [ ! -f "$TMPDIR_SESSION/active_shells/$$" ]
}

_p_mark_shell_active ()
{
    touch -- "$TMPDIR_SESSION/active_shells/$$"
}

_p_mark_shell_inactive ()
{
    if [ -f "$TMPDIR_SESSION/active_shells/$$" ]
    then
        rm -- "$TMPDIR_SESSION/active_shells/$$"
    fi
}

# clean up on exit
trap '_p_mark_shell_inactive' EXIT

if [ -n "$PARENT_SHELL_PID" -a -f "$TMPDIR_SESSION/active_shells/$PARENT_SHELL_PID" ]
then
    rm -- "$TMPDIR_SESSION/active_shells/$PARENT_SHELL_PID"
fi

# }}}

_p_prompt ()
{
    PROMPT=""
    PROMPT2=""
    RPROMPT=""

    if _p_is_shell_inactive
    then
        _p_mark_shell_active

        echo
        separator
        session-info.sh
    fi

    echo
    prompt.sh

    _p_set_insert_prompt
}
add-zsh-hook precmd _p_prompt

# vim: ft=zsh: foldmethod=marker:
