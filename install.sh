#!/usr/bin/env bash

set -Eeuo pipefail

trap 'echo "❌ Installation failed. Exiting..."; exit 1' ERR

echo "🚀 Starting MyDotfiles installation..."

if ! command -v apt >/dev/null 2>&1; then
    echo "❌ This installer only supports Ubuntu/Debian-based systems."
    exit 1
fi

DOTFILES_DIR="$(cd "$(dirname "$0")" && pwd)"

echo "📦 Updating system..."
sudo apt update && sudo apt upgrade -y

echo "📦 Installing required packages..."
sudo apt install -y software-properties-common

if [[ -f "$DOTFILES_DIR/packages/apt.txt" ]]; then
    sudo apt install -y $(grep -vE '^\s*#|^\s*$' "$DOTFILES_DIR/packages/apt.txt")
else
    sudo apt install -y \
        git \
        curl \
        build-essential \
        stow \
        zsh \
        tmux \
        kitty
fi

if ! command -v nvim >/dev/null 2>&1; then
    echo "🌙 Installing Neovim..."
    sudo add-apt-repository ppa:neovim-ppa/stable -y
    sudo apt update
    sudo apt install -y neovim
fi

mkdir -p "$HOME/.config"

backup_and_link() {
    local src="$1"
    local dest="$2"

    if [[ ! -e "$src" ]]; then
        echo "⚠️ Skipping $(basename "$dest") (source not found)"
        return
    fi

    if [[ -L "$dest" ]]; then
        rm -f "$dest"
    elif [[ -e "$dest" ]]; then
        mv "$dest" "${dest}.backup.$(date +%Y%m%d_%H%M%S)"
        echo "📁 Backed up existing: $dest"
    fi

    ln -sfn "$src" "$dest"
    echo "✅ Linked: $dest"
}

echo "🔗 Deploying configurations..."

backup_and_link "$DOTFILES_DIR/nvim" "$HOME/.config/nvim"
backup_and_link "$DOTFILES_DIR/kitty" "$HOME/.config/kitty"
backup_and_link "$DOTFILES_DIR/tmux/.tmux.conf" "$HOME/.tmux.conf"
backup_and_link "$DOTFILES_DIR/zsh/.zshrc" "$HOME/.zshrc"

echo
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "✅ Installation Complete!"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo
echo "Next steps:"
echo "  • Launch Neovim:"
echo "      nvim"
echo
echo "  • Wait for Lazy.nvim to install all plugins."
echo
echo "  • (Optional) Set Zsh as your default shell:"
echo "      chsh -s \$(which zsh)"
echo
echo "  • Restart your terminal or log out and back in."