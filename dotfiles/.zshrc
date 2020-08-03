# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000

setopt autocd extendedglob notify
setopt COMPLETE_ALIASES
unsetopt beep nomatch
bindkey -v

# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
zstyle :compinstall filename '/home/lecongkhoiviet/.zshrc'
zstyle ':completion:*' menu select
zstyle ':completion::complete:*' gain-privileges 1

autoload -Uz compinit
compinit

# Custom lines
alias ls="ls --color=auto"
alias nf="neofetch"

# End of lines added by compinstall
powerline-daemon -q

. /usr/lib/python3.8/site-packages/powerline/bindings/zsh/powerline.zsh
(cat $HOME/.config/wpg/sequences &)
export TERM=kitty
