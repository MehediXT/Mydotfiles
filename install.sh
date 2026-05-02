#!/bin/bash

# Dotfiles Installation Script for C++ Competitive Programming (NvChad Edition)
# This script installs dependencies, backs up configs, and creates symlinks
# One-command setup: bash install.sh

set -e  # Exit on error

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Get the directory where this script is located
DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BACKUP_DIR="$HOME/.backup_dotfiles"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
BACKUP_PATH="$BACKUP_DIR/backup_$TIMESTAMP"

# Required packages for different OS
UBUNTU_DEBIAN_PKGS="git neovim build-essential kitty curl wget ripgrep nodejs npm"
ARCH_PKGS="git neovim base-devel kitty curl wget ripgrep nodejs npm"

# Functions
log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[✓]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[⚠]${NC} $1"
}

log_error() {
    echo -e "${RED}[✗]${NC} $1"
}

log_section() {
    echo ""
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${CYAN}  $1${NC}"
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
}


detect_os() {
    log_section "Step 1: Detecting Operating System"
    if [ -f /etc/os-release ]; then
        . /etc/os-release
        OS=$ID
        VERSION=$VERSION_ID
        log_success "Detected: $OS $VERSION"
    else
        log_error "Could not detect OS"
        exit 1
    fi
}

install_packages() {
    log_section "Step 2: Installing Required Packages"
    
    log_info "Installing: git neovim build-essential kitty ripgrep nodejs npm curl..."
    
    if [[ "$OS" == "ubuntu" || "$OS" == "debian" ]]; then
        log_info "Using apt (Ubuntu/Debian)..."
        sudo apt update -qq || log_warning "apt update had issues, continuing..."
        sudo apt install -y $UBUNTU_DEBIAN_PKGS 2>&1 | grep -E "Setting up|already" || true
        log_success "Ubuntu/Debian packages installed!"
        
    elif [[ "$OS" == "arch" || "$OS" == "artix" ]]; then
        log_info "Using pacman (Arch Linux)..."
        sudo pacman -Sy --noconfirm $ARCH_PKGS 2>&1 | grep -E "upgrading|installing" || true
        log_success "Arch packages installed!"
        
    else
        log_warning "Unknown OS: $OS"
        log_warning "Please install manually:"
        log_warning "  - git, neovim, build-essential (or base-devel)"
        log_warning "  - kitty, curl, wget, ripgrep, nodejs, npm"
        read -p "Continue anyway? (y/n) " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            exit 1
        fi
    fi
    
    # Verify Neovim installation
    if ! command -v nvim &> /dev/null; then
        log_error "Neovim installation failed!"
        exit 1
    fi
    
    log_success "All packages installed successfully!"
}

backup_existing_configs() {
    log_section "Step 3: Backing Up Existing Configurations"
    
    mkdir -p "$BACKUP_PATH"
    local backed_up=0
    
    # List of files/folders to backup
    local config_items=(
        "$HOME/.bashrc"
        "$HOME/.profile"
        "$HOME/.gitconfig"
        "$HOME/.config/nvim"
        "$HOME/.config/kitty"
    )
    
    for item in "${config_items[@]}"; do
        if [ -e "$item" ]; then
            log_info "Backing up $(basename $item)..."
            cp -r "$item" "$BACKUP_PATH/" 2>/dev/null && ((backed_up++))
        fi
    done
    
    if [ $backed_up -gt 0 ]; then
        log_success "Backed up $backed_up configurations"
        log_info "Location: $BACKUP_PATH"
    else
        log_info "No existing configs to backup"
    fi
}

create_config_dir() {
    mkdir -p "$HOME/.config"
    mkdir -p "$HOME/.local/share/nvim"
}

create_symlinks() {
    log_section "Step 4: Creating Symlinks"
    
    # Bash configs
    log_info "Linking bash configs..."
    rm -f "$HOME/.bashrc" 2>/dev/null || true
    ln -sf "$DOTFILES_DIR/bash/.bashrc" "$HOME/.bashrc"
    log_success "~/.bashrc → $DOTFILES_DIR/bash/.bashrc"
    
    rm -f "$HOME/.profile" 2>/dev/null || true
    ln -sf "$DOTFILES_DIR/bash/.profile" "$HOME/.profile"
    log_success "~/.profile → $DOTFILES_DIR/bash/.profile"
    
    # Git config
    log_info "Linking git config..."
    rm -f "$HOME/.gitconfig" 2>/dev/null || true
    ln -sf "$DOTFILES_DIR/git/.gitconfig" "$HOME/.gitconfig"
    log_success "~/.gitconfig → $DOTFILES_DIR/git/.gitconfig"
    
    # Neovim config (full directory with all lua files)
    log_info "Linking neovim config..."
    rm -rf "$HOME/.config/nvim" 2>/dev/null || true
    ln -sf "$DOTFILES_DIR/nvim" "$HOME/.config/nvim"
    log_success "~/.config/nvim → $DOTFILES_DIR/nvim"
    
    # Kitty config
    log_info "Linking kitty config..."
    rm -rf "$HOME/.config/kitty" 2>/dev/null || true
    ln -sf "$DOTFILES_DIR/kitty" "$HOME/.config/kitty"
    log_success "~/.config/kitty → $DOTFILES_DIR/kitty"
    
    log_success "All symlinks created!"
}

setup_cp_scripts() {
    log_section "Step 5: Setting Up CP Tools"
    
    # Make cpnew executable
    chmod +x "$DOTFILES_DIR/cp/cpnew.sh"
    log_success "cpnew.sh is now executable"
    
    # Add to PATH if not already there
    if ! grep -q "dotfiles/cp" "$HOME/.bashrc"; then
        echo "" >> "$HOME/.bashrc"
        echo "# Dotfiles CP scripts" >> "$HOME/.bashrc"
        echo "export PATH=\"\$PATH:$DOTFILES_DIR/cp\"" >> "$HOME/.bashrc"
        log_success "Added CP tools to PATH"
    else
        log_info "CP tools already in PATH"
    fi
    
    log_success "Usage: cpnew <filename.cpp>"
}

install_nvim_plugins() {
    log_section "Step 6: Installing Neovim Plugins"
    
    log_info "This will take a moment (lazy.nvim downloading plugins)..."
    log_info "Waiting for lazy.nvim to initialize plugins..."
    
    # Run neovim in headless mode to trigger plugin installation
    # This will download all plugins from lazy-lock.json
    timeout 60 nvim --headless "+Lazy! sync" +qa 2>/dev/null || {
        log_warning "Plugin installation timed out or had issues"
        log_info "Plugins will be installed on first Neovim launch"
    }
    
    if [ -d "$HOME/.config/nvim/lua/plugin" ]; then
        log_success "Neovim config detected with plugins"
    fi
    
    log_success "Neovim plugin setup complete!"
}

verify_installation() {
    log_section "Step 7: Verifying Installation"
    
    local all_good=true
    
    # Check tools
    for tool in nvim git g++ kitty; do
        if command -v $tool &> /dev/null; then
            log_success "$tool installed"
        else
            log_error "$tool NOT found"
            all_good=false
        fi
    done
    
    # Check symlinks
    if [ -L "$HOME/.bashrc" ]; then
        log_success "~/.bashrc is symlinked"
    else
        log_warning "~/.bashrc is not symlinked (might be copied)"
    fi
    
    if [ -L "$HOME/.config/nvim" ]; then
        log_success "~/.config/nvim is symlinked"
    else
        log_error "~/.config/nvim is not symlinked"
        all_good=false
    fi
    
    return $([ "$all_good" = true ] && echo 0 || echo 1)
}

main() {
    clear
    echo -e "${BLUE}"
    cat << "EOF"
╔════════════════════════════════════════════════════════════════════╗
║                   DOTFILES INSTALLATION SCRIPT                     ║
║              C++ Competitive Programming + NvChad Setup            ║
╚════════════════════════════════════════════════════════════════════╝
EOF
    echo -e "${NC}"
    
    # Run installation steps
    detect_os
    install_packages
    create_config_dir
    backup_existing_configs
    create_symlinks
    setup_cp_scripts
    install_nvim_plugins
    
    # Verify
    if verify_installation; then
        VERIFY_OK=true
    else
        VERIFY_OK=false
    fi
    
    # Final summary
    log_section "🎉 Installation Complete!"
    
    echo ""
    echo -e "${GREEN}✓ Setup finished successfully!${NC}"
    echo ""
    echo -e "${YELLOW}📋 Next Steps:${NC}"
    echo ""
    echo "  1. ${CYAN}Reload your shell:${NC}"
    echo "     ${BLUE}source ~/.bashrc${NC}"
    echo ""
    echo "  2. ${CYAN}Open Neovim (plugins will download on first launch):${NC}"
    echo "     ${BLUE}nvim ~/.bashrc${NC}"
    echo ""
    echo "  3. ${CYAN}Create a new competitive programming file:${NC}"
    echo "     ${BLUE}cpnew solution.cpp${NC}"
    echo ""
    echo "  4. ${CYAN}Compile and run inside Neovim:${NC}"
    echo "     Press ${BLUE}<Space>r${NC}"
    echo ""
    echo -e "${YELLOW}📦 What Was Installed:${NC}"
    echo "  • Neovim (NvChad configuration with plugins)"
    echo "  • Kitty terminal"
    echo "  • Git (with custom aliases)"
    echo "  • Build tools (g++, make, etc.)"
    echo "  • Node.js & npm (for some Neovim plugins)"
    echo "  • ripgrep (for Neovim telescope/search)"
    echo ""
    echo -e "${YELLOW}🎯 Key Aliases:${NC}"
    echo "  • ${CYAN}ll${NC}       → ls -lah"
    echo "  • ${CYAN}gs${NC}       → git status"
    echo "  • ${CYAN}ga${NC}       → git add"
    echo "  • ${CYAN}gc${NC}       → git commit"
    echo "  • ${CYAN}gp${NC}       → git push"
    echo "  • ${CYAN}cpnew${NC}    → Create new CP file"
    echo ""
    echo -e "${YELLOW}⌨️  Neovim Shortcuts:${NC}"
    echo "  • ${CYAN}<Space>r${NC}  → Compile & run C++"
    echo "  • ${CYAN}<Space>w${NC}  → Save"
    echo "  • ${CYAN}<Space>q${NC}  → Quit"
    echo ""
    echo -e "${YELLOW}💾 Backups:${NC}"
    echo "  Location: ${BLUE}$BACKUP_PATH${NC}"
    echo ""
    
    if [ "$VERIFY_OK" = true ]; then
        echo -e "${GREEN}✓ All checks passed!${NC}"
    else
        echo -e "${YELLOW}⚠ Some checks failed. Review output above.${NC}"
    fi
    
    echo ""
    echo -e "${CYAN}═══════════════════════════════════════════════════════════════════${NC}"
    echo -e "${CYAN}🚀 Happy coding!${NC}"
    echo -e "${CYAN}═══════════════════════════════════════════════════════════════════${NC}"
    echo ""
}

# Run main function
main "$@"
