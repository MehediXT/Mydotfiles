# Portable Zsh configuration.

export EDITOR=nvim
export VISUAL=nvim
export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
# VS Code's Snap exports a private XDG data path to integrated terminals. Do
# not let terminal Neovim use that second, incomplete plugin installation.
case "${XDG_DATA_HOME:-}" in
  "" | "$HOME"/snap/*/.local/share) export XDG_DATA_HOME="$HOME/.local/share" ;;
esac
export XDG_CACHE_HOME="${XDG_CACHE_HOME:-$HOME/.cache}"
export XDG_STATE_HOME="${XDG_STATE_HOME:-$HOME/.local/state}"

path=($HOME/.local/bin $HOME/bin $path)

alias ll='ls -alF'
alias la='ls -A'
alias gs='git status'
alias ga='git add'
alias gc='git commit'
alias gp='git push'
alias gl='git log --oneline -n 10'

[[ -f "$HOME/.zshrc.local" ]] && source "$HOME/.zshrc.local"
