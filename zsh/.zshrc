# Portable Zsh configuration.

export EDITOR=nvim
export VISUAL=nvim
export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
export XDG_DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"
export XDG_CACHE_HOME="${XDG_CACHE_HOME:-$HOME/.cache}"

path=($HOME/.local/bin $HOME/bin $path)

alias ll='ls -alF'
alias la='ls -A'
alias gs='git status'
alias ga='git add'
alias gc='git commit'
alias gp='git push'
alias gl='git log --oneline -n 10'

[[ -f "$HOME/.zshrc.local" ]] && source "$HOME/.zshrc.local"