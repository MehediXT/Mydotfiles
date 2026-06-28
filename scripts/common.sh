#!/usr/bin/env bash

set -euo pipefail

IFS=$'\n\t'

DOTFILES_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
DOTFILES_HOME="${DOTFILES_HOME:-$HOME}"
DOTFILES_STATE_DIR="${DOTFILES_STATE_DIR:-$DOTFILES_HOME/.local/state/dotfiles}"
DOTFILES_BACKUP_DIR="${DOTFILES_BACKUP_DIR:-$DOTFILES_ROOT/backups}"

timestamp() {
    date +"%Y%m%d-%H%M%S"
}

host_name() {
    hostname -s 2>/dev/null || hostname 2>/dev/null || echo "host"
}

log_info() {
    printf '[INFO] %s\n' "$*"
}

log_warn() {
    printf '[WARN] %s\n' "$*" >&2
}

log_error() {
    printf '[ERROR] %s\n' "$*" >&2
}

have() {
    command -v "$1" >/dev/null 2>&1
}

is_root() {
    [[ ${EUID:-$(id -u)} -eq 0 ]]
}

run_as_root() {
    if is_root; then
        "$@"
    else
        sudo "$@"
    fi
}

ensure_dir() {
    mkdir -p "$1"
}

backup_existing_path() {
    local path="$1"
    local rel_path="${path#$DOTFILES_HOME/}"
    local target_dir="$DOTFILES_STATE_DIR/pre-restore/$rel_path"

    if [[ -e "$path" || -L "$path" ]]; then
        if [[ -e "$target_dir" || -L "$target_dir" ]]; then
            target_dir="$target_dir.$(timestamp)"
        fi
        ensure_dir "$(dirname "$target_dir")"
        mv "$path" "$target_dir"
    fi
}

safe_link_file() {
    local source="$1"
    local target="$2"

    if [[ ! -e "$source" ]]; then
        log_warn "Skipping missing source: $source"
        return 0
    fi

    if [[ -L "$target" ]]; then
        local current_target
        current_target="$(readlink -f "$target" || true)"
        if [[ "$current_target" == "$(readlink -f "$source")" ]]; then
            log_info "Link already correct: $target"
            return 0
        fi
    fi

    backup_existing_path "$target"
    ensure_dir "$(dirname "$target")"
    ln -s "$source" "$target"
    log_info "Linked $target -> $source"
}

safe_link_dir() {
    local source="$1"
    local target="$2"

    if [[ ! -e "$source" ]]; then
        log_warn "Skipping missing source directory: $source"
        return 0
    fi

    if [[ -L "$target" ]]; then
        local current_target
        current_target="$(readlink -f "$target" || true)"
        if [[ "$current_target" == "$(readlink -f "$source")" ]]; then
            log_info "Link already correct: $target"
            return 0
        fi
    fi

    backup_existing_path "$target"
    ensure_dir "$(dirname "$target")"
    ln -sfn "$source" "$target"
    log_info "Linked $target -> $source"
}

copy_if_exists() {
    local source="$1"
    local target="$2"

    if [[ ! -e "$source" ]]; then
        return 0
    fi

    ensure_dir "$(dirname "$target")"
    cp -a "$source" "$target"
}

copy_tree_if_exists() {
    local source="$1"
    local target="$2"

    if [[ ! -e "$source" ]]; then
        return 0
    fi

    ensure_dir "$target"
    cp -a "$source"/. "$target"/
}

write_wrapper_script() {
    local target="$1"
    local entrypoint="$2"

    ensure_dir "$(dirname "$target")"
    cat > "$target" <<EOF
#!/usr/bin/env bash
exec "$entrypoint" "\$@"
EOF
    chmod +x "$target"
}

read_clean_lines() {
    local file="$1"

    if [[ ! -f "$file" ]]; then
        return 0
    fi

    grep -vE '^[[:space:]]*#|^[[:space:]]*$' "$file"
}

detect_vscode_user_dir() {
    if [[ -d "$HOME/snap/code/common/.config/Code/User" ]]; then
        printf '%s\n' "$HOME/snap/code/common/.config/Code/User"
    elif [[ -d "$HOME/snap/code/current/.config/Code/User" ]]; then
        printf '%s\n' "$HOME/snap/code/current/.config/Code/User"
    elif [[ -d "$HOME/.config/Code/User" ]]; then
        printf '%s\n' "$HOME/.config/Code/User"
    else
        printf '%s\n' "$HOME/.config/Code/User"
    fi
}

detect_code_binary() {
    local candidate
    for candidate in code code-insiders codium; do
        if have "$candidate"; then
            printf '%s\n' "$candidate"
            return 0
        fi
    done

    return 1
}

ensure_neovim_ppa() {
    if ! have apt-get; then
        return 0
    fi

    if ! have add-apt-repository; then
        run_as_root apt-get update
        run_as_root env DEBIAN_FRONTEND=noninteractive apt-get install -y software-properties-common
    fi

    if grep -rq 'neovim-ppa/stable' /etc/apt/sources.list /etc/apt/sources.list.d/ 2>/dev/null; then
        return 0
    fi

    log_info "Adding Neovim stable PPA (required for modern Lua configs)"
    run_as_root add-apt-repository ppa:neovim-ppa/stable -y
}

install_apt_packages_from_file() {
    local file="$1"

    if ! have apt-get; then
        log_warn "apt-get not found; skipping APT packages"
        return 0
    fi

    mapfile -t packages < <(read_clean_lines "$file" || true)
    if [[ ${#packages[@]} -eq 0 ]]; then
        return 0
    fi

    if [[ " ${packages[*]} " == *" neovim "* ]]; then
        ensure_neovim_ppa
    fi

    run_as_root apt-get update
    run_as_root env DEBIAN_FRONTEND=noninteractive apt-get install -y "${packages[@]}"
}

install_snap_packages_from_file() {
    local file="$1"

    if ! have snap; then
        log_warn "snap not found; skipping snap packages"
        return 0
    fi

    while IFS='|' read -r package_name package_flags; do
        [[ -z "$package_name" ]] && continue
        [[ "$package_name" =~ ^# ]] && continue

        if snap list "$package_name" >/dev/null 2>&1; then
            log_info "Snap already installed: $package_name"
            continue
        fi

        if [[ "${package_flags:-}" == *classic* ]]; then
            run_as_root snap install "$package_name" --classic
        else
            run_as_root snap install "$package_name"
        fi
    done < "$file"
}

install_flatpak_packages_from_file() {
    local file="$1"

    if ! have flatpak; then
        log_warn "flatpak not found; skipping flatpak packages"
        return 0
    fi

    if ! flatpak remote-list | grep -q '^flathub'; then
        run_as_root flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
    fi

    while IFS='|' read -r app_id remote_name; do
        [[ -z "$app_id" ]] && continue
        [[ "$app_id" =~ ^# ]] && continue

        remote_name="${remote_name:-flathub}"
        if flatpak list --app --columns=application | grep -qx "$app_id"; then
            log_info "Flatpak already installed: $app_id"
            continue
        fi

        flatpak install -y "$remote_name" "$app_id"
    done < "$file"
}

restore_vscode_extensions_from_file() {
    local file="$1"
    local code_bin

    if ! code_bin="$(detect_code_binary 2>/dev/null)"; then
        log_warn "VS Code binary not found; skipping extension restore"
        return 0
    fi

    while IFS= read -r extension; do
        [[ -z "$extension" ]] && continue
        [[ "$extension" =~ ^# ]] && continue

        "$code_bin" --install-extension "$extension" --force >/dev/null
        log_info "Installed VS Code extension: $extension"
    done < "$file"
}