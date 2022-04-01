#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias vim='nvim'
alias ls='ls --color=auto'
PS1='[\u@\h \W]\$ '
set -o vi

# Starship Prompt
eval "$(starship init bash)"
