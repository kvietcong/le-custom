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

eval "$(zoxide init bash)"

# Starship Prompt
eval "$(starship init bash)"
