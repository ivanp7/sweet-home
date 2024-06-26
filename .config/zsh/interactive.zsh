# Configuration {{{

# zsh directories
mkdir -p -- "$XDG_CACHE_HOME/zsh"
mkdir -p -- "$XDG_DATA_HOME/zsh"
mkdir -p -- "$XDG_STATE_HOME/zsh"

# options
HISTFILE="$XDG_STATE_HOME/zsh/history"
HISTSIZE=100000
SAVEHIST=$HISTSIZE

setopt APPEND_HISTORY HIST_IGNORE_ALL_DUPS HIST_FIND_NO_DUPS
setopt HIST_IGNORE_SPACE
setopt AUTO_PUSHD PUSHD_IGNORE_DUPS
setopt NOMATCH COMPLETE_ALIASES
setopt IGNORE_EOF
unsetopt BEEP NOTIFY

autoload -Uz add-zsh-hook

# help
autoload -Uz run-help
autoload -Uz run-help-git
autoload -Uz run-help-ip
autoload -Uz run-help-sudo
alias help=run-help

# completion
fpath=($fpath "$(realpath -L "$ZDOTDIR/comp.d")")

autoload -Uz compinit
zmodload zsh/complist
zstyle ':completion:*' add-space false
zstyle ':completion:*' menu select
zstyle ':completion:*' cache-path "$XDG_CACHE_HOME/zsh/zcompcache"
zstyle ':completion::complete:*' use-cache 1
zstyle ':completion:*:descriptions' format '%U%B%d%b%u'
zstyle ':completion:*:warnings' format '%BSorry, no matches for: %d%b'
compinit -d "$XDG_CACHE_HOME/zsh/zcompdump-$ZSH_VERSION" -i
_comp_options+=(globdots) # Include hidden files

# syntax highlighting
zsh_syntax_highlighting=$(find /usr/share/zsh -type f -name "zsh-syntax-highlighting.zsh" 2> /dev/null)
[ -f "$zsh_syntax_highlighting" ] || zsh_syntax_highlighting=$(find /usr/share/zsh-syntax-highlighting \
    -type f -name "zsh-syntax-highlighting.zsh" 2> /dev/null)

[ ! -f "$zsh_syntax_highlighting" ] ||
     . "$zsh_syntax_highlighting"

# "command not found"
[ ! -f "/usr/share/doc/pkgfile/command-not-found.zsh" ] ||
     . "/usr/share/doc/pkgfile/command-not-found.zsh"

# dircolors
eval $(dircolors)

# freeze terminal (disable changes of the settings except screen size)
ttyctl -f

# }}}
# Keys {{{

bindkey -v

autoload edit-command-line
zle -N edit-command-line

autoload -Uz up-line-or-beginning-search down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search

# create a zkbd compatible hash;
# to add other keys to this hash, see: man 5 terminfo
typeset -g -A key

key[Home]="${terminfo[khome]}"
key[End]="${terminfo[kend]}"
key[Insert]="${terminfo[kich1]}"
key[Backspace]="${terminfo[kbs]}"
key[Delete]="${terminfo[kdch1]}"
key[Up]="${terminfo[kcuu1]}"
key[Down]="${terminfo[kcud1]}"
key[Left]="${terminfo[kcub1]}"
key[Right]="${terminfo[kcuf1]}"
key[PageUp]="${terminfo[kpp]}"
key[PageDown]="${terminfo[knp]}"
key[ShiftTab]="${terminfo[kcbt]}"

# setup key accordingly
[ -n "${key[Insert]}"    ] && bindkey -- "${key[Insert]}"    overwrite-mode
[ -n "${key[Backspace]}" ] && bindkey -- "${key[Backspace]}" backward-delete-char
[ -n "${key[Delete]}"    ] && bindkey -- "${key[Delete]}"    delete-char
[ -n "${key[PageUp]}"    ] && bindkey -- "${key[PageUp]}"    beginning-of-buffer-or-history
[ -n "${key[PageDown]}"  ] && bindkey -- "${key[PageDown]}"  end-of-buffer-or-history
[ -n "${key[ShiftTab]}"  ] && bindkey -- "${key[ShiftTab]}"  reverse-menu-complete

bindkey '^[[A' up-line-or-beginning-search
bindkey '^[[B' down-line-or-beginning-search
bindkey '^[[D' backward-char
bindkey '^[[C' forward-char
bindkey '^[[H' beginning-of-line
bindkey '^[[F' end-of-line

bindkey -M vicmd 'k' up-line-or-beginning-search
bindkey -M vicmd 'j' down-line-or-beginning-search
bindkey -M menuselect '^[[Z' reverse-menu-complete

bindkey '\C-b' backward-char
bindkey '\C-f' forward-char
bindkey '\C-a' beginning-of-line
bindkey '\C-e' end-of-line
bindkey '\C-p' up-line-or-beginning-search
bindkey '\C-n' down-line-or-beginning-search
bindkey '\C-u' backward-kill-line
bindkey '\C-k' kill-line
bindkey '\C-h' backward-delete-char

bindkey '^[^M' self-insert-unmeta

edit_command_in_vim ()
{
    _p_set_abandoned_prompt
    zle reset-prompt
    edit-command-line
}
zle -N edit_command_in_vim

bindkey '^v' edit_command_in_vim
bindkey -M vicmd '^v' edit_command_in_vim

exit_zsh ()
{
    _p_set_abandoned_prompt
    zle reset-prompt
    exit 0
}
zle -N exit_zsh
bindkey '^d' exit_zsh

# Finally, make sure the terminal is in application mode, when zle is
# active. Only then are the values from $terminfo valid.
if (( ${+terminfo[smkx]} && ${+terminfo[rmkx]} )); then
    autoload -Uz add-zle-hook-widget
    function zle_application_mode_start {
        echoti smkx
    }
    function zle_application_mode_stop {
        echoti rmkx
    }
    add-zle-hook-widget -Uz zle-line-init zle_application_mode_start
    add-zle-hook-widget -Uz zle-line-finish zle_application_mode_stop
fi

# command history {{{

typeset -A _p_buffers

rep ()
{
    [ -z "$BUFFER" ] && return 1
    BUFFER="$_p_buffers[$BUFFER]"
    zle vi-beginning-of-line
}
zle -N rep

bindkey '^g' rep

# }}}
# save command output to a tmp file {{{

save ()
{
    if [ -z "$_p_shell_output_dir" ]
    then
        if [ ! -d "$TMPDIR_SESSION/output/$$" ]
        then
            _p_shell_output_dir="$TMPDIR_SESSION/output/$$"
            mkdir -p -- "$_p_shell_output_dir"
        else
            _p_shell_output_dir="$(mktemp -d -p "$TMPDIR_SESSION/output" "$$.XXXX")"
        fi
    fi

    tee "$_p_shell_output_dir/$_p_command_number"
}

# }}}
# fzf {{{

[ ! -f "/usr/share/fzf/key-bindings.zsh" ] ||
     . "/usr/share/fzf/key-bindings.zsh"

[ ! -f "/usr/share/fzf/completion.zsh" ] ||
     . "/usr/share/fzf/completion.zsh"

bindkey '^y' fzf-cd-widget

# }}}
# }}}

# vim: ft=zsh: foldmethod=marker:
