# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000

setopt autocd extendedglob notify
setopt COMPLETE_ALIASES
unsetopt beep nomatch

# Vi Mode
bindkey -v

# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
zstyle :compinstall filename '/home/lecongkhoiviet/.zshrc'
zstyle ':completion:*' menu select
zstyle ':completion::complete:*' gain-privileges 1

# End of lines added by compinstall
autoload -Uz compinit
compinit

# Custom lines
alias ls="ls --color=auto"
alias nf="neofetch"
alias la="ls -A"
alias mv="mv -i"
alias rm="rm -I"
alias cp="cp -i"
alias grep="grep --color=auto"
alias :q="exit"

# Powerline addon
powerline-daemon -q
. /usr/lib/python3.8/site-packages/powerline/bindings/zsh/powerline.zsh

# Color Scheme Application
(cat $HOME/.config/wpg/sequences &)

# Proper Kitty autocompletion
kitty + complete setup zsh | source /dev/stdin

# Variables
export EDITOR=vim
export VISUAL=vim
