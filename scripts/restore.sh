#!/usr/bin/env bash

set -euo pipefail

source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/common.sh"

SNAPSHOT_ROOT=""

usage() {
    cat <<'EOF'
Usage: bash scripts/restore.sh [--snapshot DIR]

Installs packages, restores tracked configuration files, and optionally
imports machine-specific state from a backup snapshot.
EOF
}

parse_args() {
    while [[ $# -gt 0 ]]; do
        case "$1" in
            --snapshot)
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

install_packages() {
    log_info "Installing packages from manifests"

    install_apt_packages_from_file "$DOTFILES_ROOT/packages/apt.txt"

    if [[ -n "$SNAPSHOT_ROOT" ]]; then
        install_apt_packages_from_file "$SNAPSHOT_ROOT/packages/apt.txt"
    fi

    install_snap_packages_from_file "$DOTFILES_ROOT/packages/snap.txt"
    if [[ -n "$SNAPSHOT_ROOT" ]]; then
        install_snap_packages_from_file "$SNAPSHOT_ROOT/packages/snap.txt"
    fi

    install_flatpak_packages_from_file "$DOTFILES_ROOT/packages/flatpak.txt"
    if [[ -n "$SNAPSHOT_ROOT" ]]; then
        install_flatpak_packages_from_file "$SNAPSHOT_ROOT/packages/flatpak.txt"
    fi
}

restore_tracked_configs() {
    log_info "Restoring tracked configuration files"

    safe_link_file "$DOTFILES_ROOT/bash/.bashrc" "$HOME/.bashrc"
    safe_link_file "$DOTFILES_ROOT/bash/.profile" "$HOME/.profile"
    safe_link_file "$DOTFILES_ROOT/git/.gitconfig" "$HOME/.gitconfig"
    safe_link_dir "$DOTFILES_ROOT/kitty" "$HOME/.config/kitty"
    safe_link_dir "$DOTFILES_ROOT/nvim" "$HOME/.config/nvim"
    safe_link_file "$DOTFILES_ROOT/tmux/.tmux.conf" "$HOME/.tmux.conf"
    safe_link_file "$DOTFILES_ROOT/zsh/.zshrc" "$HOME/.zshrc"
    safe_link_file "$DOTFILES_ROOT/zsh/.zprofile" "$HOME/.zprofile"

    if [[ -f "$DOTFILES_ROOT/cp/cpnew.sh" ]]; then
        ensure_dir "$HOME/.local/bin"
        safe_link_file "$DOTFILES_ROOT/cp/cpnew.sh" "$HOME/.local/bin/cpnew"
        chmod +x "$DOTFILES_ROOT/cp/cpnew.sh"
    fi

    if [[ -f "$DOTFILES_ROOT/scripts/backup.sh" ]]; then
        ensure_dir "$HOME/.local/bin"
        write_wrapper_script "$HOME/.local/bin/dotfiles-backup" "$DOTFILES_ROOT/scripts/backup.sh"
        write_wrapper_script "$HOME/.local/bin/dotfiles-restore" "$DOTFILES_ROOT/scripts/restore.sh"
    fi
}

restore_snapshot_configs() {
    [[ -n "$SNAPSHOT_ROOT" ]] || return 0

    log_info "Restoring snapshot-specific files from $SNAPSHOT_ROOT"

    ensure_dir "$HOME/.ssh"
    copy_if_exists "$SNAPSHOT_ROOT/config/ssh/config" "$HOME/.ssh/config"
    copy_if_exists "$SNAPSHOT_ROOT/config/ssh/known_hosts" "$HOME/.ssh/known_hosts"
    copy_if_exists "$SNAPSHOT_ROOT/config/ssh/known_hosts2" "$HOME/.ssh/known_hosts2"
    copy_tree_if_exists "$SNAPSHOT_ROOT/config/ssh/config.d" "$HOME/.ssh/config.d"

    if [[ -d "$SNAPSHOT_ROOT/config/custom-bin" ]]; then
        ensure_dir "$HOME/.local/bin"
        cp -a "$SNAPSHOT_ROOT/config/custom-bin"/. "$HOME/.local/bin"/
        chmod -R u+rx "$HOME/.local/bin"
    fi

    local vscode_user_dir
    vscode_user_dir="$(detect_vscode_user_dir)"
    ensure_dir "$vscode_user_dir"
    copy_if_exists "$SNAPSHOT_ROOT/config/vscode/settings.json" "$vscode_user_dir/settings.json"
    copy_if_exists "$SNAPSHOT_ROOT/config/vscode/keybindings.json" "$vscode_user_dir/keybindings.json"
    copy_tree_if_exists "$SNAPSHOT_ROOT/config/vscode/snippets" "$vscode_user_dir/snippets"
    copy_if_exists "$SNAPSHOT_ROOT/config/vscode/argv.json" "$vscode_user_dir/argv.json"

    if [[ -f "$SNAPSHOT_ROOT/config/terminal/gnome-terminal.dconf" ]] && have dconf; then
        dconf load /org/gnome/terminal/legacy/profiles:/ < "$SNAPSHOT_ROOT/config/terminal/gnome-terminal.dconf" || true
        log_info "Restored GNOME Terminal profile settings"
    fi
}

restore_vscode_extensions() {
    local extension_file="$DOTFILES_ROOT/vscode/extensions.txt"

    if [[ -n "$SNAPSHOT_ROOT" && -f "$SNAPSHOT_ROOT/vscode/extensions.txt" ]]; then
        extension_file="$SNAPSHOT_ROOT/vscode/extensions.txt"
    fi

    if [[ -f "$extension_file" ]]; then
        restore_vscode_extensions_from_file "$extension_file"
    fi
}

main() {
    parse_args "$@"

    ensure_dir "$DOTFILES_STATE_DIR"
    ensure_dir "$HOME/.config"
    ensure_dir "$HOME/.local/bin"

    install_packages
    restore_tracked_configs
    restore_snapshot_configs
    restore_vscode_extensions

    log_info "Restore complete"
    log_info "Reload your shell or run: source ~/.bashrc"
}

main "$@"