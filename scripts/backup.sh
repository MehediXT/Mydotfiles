#!/usr/bin/env bash

set -euo pipefail

source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/common.sh"

SNAPSHOT_ROOT=""

usage() {
    cat <<'EOF'
Usage: bash scripts/backup.sh [--output DIR]

Creates a machine snapshot of configuration files, package lists, and
selected editor/terminal state. Secrets and private SSH keys are excluded.
EOF
}

parse_args() {
    while [[ $# -gt 0 ]]; do
        case "$1" in
            --output)
                SNAPSHOT_ROOT="$2"
                shift 2
                ;;
            -h|--help)
                usage
                exit 0
                ;;
            *)
                log_error "Unknown argument: $1"
                usage
                exit 1
                ;;
        esac
    done
}

backup_configs() {
    local config_root="$SNAPSHOT_ROOT/config"

    log_info "Backing up shell, git, SSH, editor, and terminal configuration"
    ensure_dir "$config_root"

    copy_if_exists "$HOME/.bashrc" "$config_root/bash/.bashrc"
    copy_if_exists "$HOME/.profile" "$config_root/bash/.profile"
    copy_if_exists "$HOME/.bash_aliases" "$config_root/bash/.bash_aliases"
    copy_if_exists "$HOME/.zshrc" "$config_root/zsh/.zshrc"
    copy_if_exists "$HOME/.zprofile" "$config_root/zsh/.zprofile"
    copy_if_exists "$HOME/.zshenv" "$config_root/zsh/.zshenv"
    copy_if_exists "$HOME/.gitconfig" "$config_root/git/.gitconfig"
    copy_if_exists "$HOME/.gitignore_global" "$config_root/git/.gitignore_global"
    copy_if_exists "$HOME/.tmux.conf" "$config_root/tmux/.tmux.conf"
    copy_tree_if_exists "$HOME/.config/tmux" "$config_root/tmux/config"
    copy_tree_if_exists "$HOME/.config/kitty" "$config_root/kitty"
    copy_tree_if_exists "$HOME/.config/nvim" "$config_root/nvim"

    if [[ -d "$HOME/.ssh" ]]; then
        ensure_dir "$config_root/ssh"
        copy_if_exists "$HOME/.ssh/config" "$config_root/ssh/config"
        copy_if_exists "$HOME/.ssh/known_hosts" "$config_root/ssh/known_hosts"
        copy_if_exists "$HOME/.ssh/known_hosts2" "$config_root/ssh/known_hosts2"
        copy_tree_if_exists "$HOME/.ssh/config.d" "$config_root/ssh/config.d"
        find "$HOME/.ssh" -maxdepth 1 -type f -name '*.pub' -exec cp -a {} "$config_root/ssh/" \;
    fi

    if [[ -d "$HOME/.local/bin" ]]; then
        copy_tree_if_exists "$HOME/.local/bin" "$config_root/custom-bin"
    fi

    local vscode_user_dir
    vscode_user_dir="$(detect_vscode_user_dir)"
    if [[ -d "$vscode_user_dir" ]]; then
        ensure_dir "$config_root/vscode"
        copy_if_exists "$vscode_user_dir/settings.json" "$config_root/vscode/settings.json"
        copy_if_exists "$vscode_user_dir/keybindings.json" "$config_root/vscode/keybindings.json"
        copy_tree_if_exists "$vscode_user_dir/snippets" "$config_root/vscode/snippets"
        copy_if_exists "$vscode_user_dir/argv.json" "$config_root/vscode/argv.json"
    fi

    if have dconf; then
        ensure_dir "$config_root/terminal"
        if dconf dump /org/gnome/terminal/legacy/profiles:/ > "$config_root/terminal/gnome-terminal.dconf" 2>/dev/null; then
            log_info "Captured GNOME Terminal profile settings"
        else
            rm -f "$config_root/terminal/gnome-terminal.dconf"
        fi
    fi
}

backup_packages() {
    local package_root="$SNAPSHOT_ROOT/packages"

    log_info "Backing up package inventories"
    ensure_dir "$package_root"

    if have apt-mark; then
        apt-mark showmanual | sort > "$package_root/apt.txt"
    fi

    if have snap; then
        snap list 2>/dev/null | awk 'NR>1 {print $1 "|" ($6 ~ /classic/ ? "classic" : "")}' | sort -u > "$package_root/snap.txt"
    fi

    if have flatpak; then
        flatpak list --app --columns=application,origin 2>/dev/null | awk 'NR>1 {print $1 "|" ($2 ? $2 : "flathub")}' | sort -u > "$package_root/flatpak.txt"
    fi
}

backup_vscode_extensions() {
    local vscode_root="$SNAPSHOT_ROOT/vscode"
    local code_bin

    ensure_dir "$vscode_root"
    if code_bin="$(detect_code_binary 2>/dev/null)"; then
        "$code_bin" --list-extensions | sort -u > "$vscode_root/extensions.txt"
    else
        : > "$vscode_root/extensions.txt"
    fi
}

write_manifest() {
    cat > "$SNAPSHOT_ROOT/manifest.txt" <<EOF
host=$(host_name)
timestamp=$(timestamp)
repo_root=$DOTFILES_ROOT
user=$USER
EOF
}

main() {
    parse_args "$@"

    if [[ -z "$SNAPSHOT_ROOT" ]]; then
        SNAPSHOT_ROOT="$DOTFILES_BACKUP_DIR/$(host_name)/$(timestamp)"
    fi

    ensure_dir "$SNAPSHOT_ROOT"
    write_manifest
    backup_configs
    backup_packages
    backup_vscode_extensions

    log_info "Backup complete: $SNAPSHOT_ROOT"
}

main "$@"