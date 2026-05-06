#
# ~/.bashrc
#
EDITOR=nvim

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias vim='nvim'
alias ls='exa --icons'
PS1='[\u@\h \W]\$ '

set -o vi
bind -m vi-command 'Control-l: clear-screen'
bind -m vi-insert 'Control-l: clear-screen'

if type "zoxide" &> /dev/null; then
    eval "$(zoxide init bash)"
else
    echo Zoxide not installed
fi

# Starship Prompt
if type "starship" &> /dev/null; then
    eval "$(starship init bash)"
else
    echo "Starship not installed"
fi

export PATH=~/.local/bin:$PATH
