# Login-shell Zsh settings.

export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
case "${XDG_DATA_HOME:-}" in
  "" | "$HOME"/snap/*/.local/share) export XDG_DATA_HOME="$HOME/.local/share" ;;
esac
export XDG_CACHE_HOME="${XDG_CACHE_HOME:-$HOME/.cache}"
export XDG_STATE_HOME="${XDG_STATE_HOME:-$HOME/.local/state}"
export PATH="$HOME/.local/bin:$HOME/bin:$PATH"

[[ -f "$HOME/.zprofile.local" ]] && source "$HOME/.zprofile.local"
