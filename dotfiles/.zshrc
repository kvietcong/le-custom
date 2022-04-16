# History and caching
HISTSIZE=1000
SAVEHIST=1000
HISTFILE=~/.cache/zsh/history
EDITOR=nvim

setopt autocd extendedglob notify
setopt COMPLETE_ALIASES
unsetopt beep nomatch
setopt prompt_subst

# Auto complete
zstyle :compinstall filename "/home/lecongkhoiviet/.zshrc"
zstyle ":completion::complete:*" gain-privileges 1
zstyle ":completion:*" menu select
_comp_options+=(globdots) # Auto complete hidden files
zmodload zsh/complist
autoload -Uz compinit
compinit

# Vi Mode options
bindkey -v
autoload edit-command-line; zle -N edit-command-line
bindkey "^e" edit-command-line
bindkey '^R' history-incremental-search-backward

# Change cursor shape for different vi modes.
function zle-keymap-select {
  if [[ ${KEYMAP} == vicmd ]] ||
     [[ $1 = 'block' ]]; then
    echo -ne '\e[1 q'
  elif [[ ${KEYMAP} == main ]] ||
       [[ ${KEYMAP} == viins ]] ||
       [[ ${KEYMAP} = '' ]] ||
       [[ $1 = 'beam' ]]; then
    echo -ne '\e[5 q'
  fi
}
zle -N zle-keymap-select
zle-line-init() {
    zle -K viins # initiate `vi insert` as keymap (can be removed if `bindkey -V` has been set elsewhere)
    echo -ne "\e[5 q"
}
zle -N zle-line-init
echo -ne '\e[5 q' # Use beam shape cursor on startup.
preexec() { echo -ne '\e[5 q' ;} # Use beam shape cursor for each new prompt.
bindkey -M menuselect "^P" vi-up-line-or-history
bindkey -M menuselect "^N" vi-down-line-or-history

# Custom lines
alias ls="exa --icons"
alias la="ls -a"
alias mv="mv -i"
alias rm="rm -I"
alias cp="cp -i"
alias grep="grep --color=auto"
alias vim="nvim"
alias rice="cd ~/le-custom/dotfiles"
alias compat="sudo mount --bind ~/.local/share/Steam/steamapps/compatdata/"
alias gpusage="watch -d -n 0.5 nvidia-smi"

# Color Scheme Application (wpgtk)
# (cat $HOME/.config/wpg/sequences &)

# Proper Kitty autocompletion
# kitty + complete setup zsh | source /dev/stdin

eval "$(zoxide init zsh)"

# Variables
export EDITOR=nvim
export VISUAL=nvim

# Starship
eval "$(starship init zsh)"

