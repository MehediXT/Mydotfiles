# Portable Zsh configuration.

export EDITOR=nvim
export VISUAL=nvim
export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
# Original default kept for reference:
# export XDG_DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"
# VS Code's Snap exports a private XDG data path to integrated terminals. Do
# not let terminal Neovim use that second, incomplete plugin installation.
if [[ -z "${XDG_DATA_HOME:-}" || "$XDG_DATA_HOME" == "$HOME"/snap/*/.local/share ]]; then
  export XDG_DATA_HOME="$HOME/.local/share"
fi
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
