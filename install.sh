#!/usr/bin/env bash

set -Eeuo pipefail

SCRIPT_DIR=$(CDPATH= cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)
TARGET_HOME=${DOTFILES_TARGET_HOME:-$HOME}
PATH="$TARGET_HOME/.local/bin:/snap/bin:$PATH"

DRY_RUN=0
INSTALL_PACKAGES=1
INSTALL_EXTRAS=1
SYNC_NEOVIM=1
INSTALL_VSCODE_EXTENSIONS=1
CHANGE_SHELL=0
BACKUP_DIR=""
TEMP_DIR=""

usage() {
  cat <<'EOF'
Usage: ./install.sh [options]

Install this repository's dotfiles on an Ubuntu/Debian Linux machine.

Options:
  --dry-run             Show what would change without changing anything
  --no-packages         Skip APT, Snap, and Flatpak package installation
  --no-extras           Skip Deno and JetBrainsMono Nerd Font installation
  --no-neovim-sync      Skip the initial Lazy.nvim plugin synchronization
  --no-vscode           Skip VS Code extension installation
  --change-shell        Change the current user's login shell to Zsh
  -h, --help            Show this help

Existing config files are moved to ~/.dotfiles-backup/<timestamp-pid>/ before
the repository files are linked. The script is safe to run more than once.
EOF
}

log() {
  printf '[dotfiles] %s\n' "$*"
}

warn() {
  printf '[dotfiles] WARNING: %s\n' "$*" >&2
}

die() {
  printf '[dotfiles] ERROR: %s\n' "$*" >&2
  exit 1
}

print_command() {
  printf '[dry-run]'
  printf ' %q' "$@"
  printf '\n'
}

run() {
  if ((DRY_RUN)); then
    print_command "$@"
  else
    "$@"
  fi
}

run_as_root() {
  if ((DRY_RUN)); then
    print_command sudo "$@"
  else
    sudo "$@"
  fi
}

cleanup() {
  if [[ -n "$TEMP_DIR" && -d "$TEMP_DIR" ]]; then
    rm -rf -- "$TEMP_DIR"
  fi
}

new_temp_dir() {
  cleanup
  TEMP_DIR=$(mktemp -d "${TMPDIR:-/tmp}/dotfiles-install.XXXXXX")
}

trim() {
  local value=$1
  value="${value#"${value%%[![:space:]]*}"}"
  value="${value%"${value##*[![:space:]]}"}"
  printf '%s' "$value"
}

read_apt_packages() {
  local manifest=$1 line package
  APT_PACKAGES=()

  while IFS= read -r line || [[ -n "$line" ]]; do
    line=${line%%#*}
    package=$(trim "$line")
    [[ -z "$package" ]] && continue
    [[ "$package" =~ ^[A-Za-z0-9][A-Za-z0-9+._:-]*$ ]] ||
      die "Invalid APT package entry: $package"
    APT_PACKAGES+=("$package")
  done <"$manifest"
}

install_apt_packages() {
  command -v apt-get >/dev/null 2>&1 ||
    die "Package installation currently supports Ubuntu/Debian (apt-get). Re-run with --no-packages on another distribution."
  command -v sudo >/dev/null 2>&1 || die "sudo is required to install system packages."

  read_apt_packages "$SCRIPT_DIR/packages/apt.txt"
  ((${#APT_PACKAGES[@]})) || return

  log "Updating APT metadata and installing ${#APT_PACKAGES[@]} packages"
  run_as_root apt-get update
  run_as_root env DEBIAN_FRONTEND=noninteractive apt-get install -y "${APT_PACKAGES[@]}"
}

install_snap_packages() {
  local manifest=$SCRIPT_DIR/packages/snap.txt line package flags extra
  local -a args

  [[ -f "$manifest" ]] || return
  if ! command -v snap >/dev/null 2>&1 && ((!DRY_RUN)); then
    warn "snap is unavailable; skipping Snap packages."
    return
  fi

  while IFS= read -r line || [[ -n "$line" ]]; do
    line=${line%%#*}
    line=$(trim "$line")
    [[ -z "$line" ]] && continue

    IFS='|' read -r package flags extra <<<"$line"
    package=$(trim "$package")
    flags=$(trim "${flags:-}")
    [[ -z "${extra:-}" && "$package" =~ ^[A-Za-z0-9][A-Za-z0-9+._-]*$ ]] ||
      die "Invalid Snap entry: $line"

    if ((!DRY_RUN)) && snap list "$package" >/dev/null 2>&1; then
      log "Snap package already installed: $package"
      continue
    fi

    args=(snap install "$package")
    case "$flags" in
      "") ;;
      classic) args+=(--classic) ;;
      *) die "Unsupported Snap flags for $package: $flags" ;;
    esac
    run_as_root "${args[@]}"
  done <"$manifest"
}

install_flatpak_packages() {
  local manifest=$SCRIPT_DIR/packages/flatpak.txt line app remote extra

  [[ -f "$manifest" ]] || return
  if ! command -v flatpak >/dev/null 2>&1 && ((!DRY_RUN)); then
    warn "flatpak is unavailable; skipping Flatpak applications."
    return
  fi

  while IFS= read -r line || [[ -n "$line" ]]; do
    line=${line%%#*}
    line=$(trim "$line")
    [[ -z "$line" ]] && continue

    IFS='|' read -r app remote extra <<<"$line"
    app=$(trim "$app")
    remote=$(trim "${remote:-flathub}")
    [[ -z "${extra:-}" && "$app" =~ ^[A-Za-z0-9][A-Za-z0-9._-]*$ ]] ||
      die "Invalid Flatpak entry: $line"
    run flatpak install -y --noninteractive "$remote" "$app"
  done <"$manifest"
}

install_deno() {
  local arch asset base_url

  if command -v deno >/dev/null 2>&1; then
    log "Deno already installed: $(deno --version | head -n 1)"
    return
  fi
  if ((DRY_RUN)); then
    log "Would install a checksum-verified Deno binary in $TARGET_HOME/.local/bin"
    return
  fi

  case "$(uname -m)" in
    x86_64) arch=x86_64 ;;
    aarch64 | arm64) arch=aarch64 ;;
    *) warn "No Deno binary configured for architecture $(uname -m); skipping Deno."; return ;;
  esac

  command -v curl >/dev/null 2>&1 || die "curl is required to install Deno."
  command -v unzip >/dev/null 2>&1 || die "unzip is required to install Deno."
  command -v sha256sum >/dev/null 2>&1 || die "sha256sum is required to verify Deno."

  asset="deno-${arch}-unknown-linux-gnu.zip"
  base_url="https://github.com/denoland/deno/releases/latest/download"
  new_temp_dir
  log "Downloading and verifying Deno"
  curl -fsSL "$base_url/$asset" -o "$TEMP_DIR/$asset"
  curl -fsSL "$base_url/$asset.sha256sum" -o "$TEMP_DIR/$asset.sha256sum"
  (cd "$TEMP_DIR" && sha256sum -c "$asset.sha256sum")
  unzip -oq "$TEMP_DIR/$asset" -d "$TEMP_DIR/deno"
  mkdir -p "$TARGET_HOME/.local/bin"
  install -m 0755 "$TEMP_DIR/deno/deno" "$TARGET_HOME/.local/bin/deno"
}

install_nerd_font() {
  local version=v3.5.0 base_url checksum font_dir

  if command -v fc-list >/dev/null 2>&1 && grep -Fqi 'JetBrainsMono Nerd Font' < <(fc-list 2>/dev/null); then
    log "JetBrainsMono Nerd Font is already installed"
    return
  fi
  if ((DRY_RUN)); then
    log "Would install checksum-verified JetBrainsMono Nerd Font $version"
    return
  fi

  command -v curl >/dev/null 2>&1 || die "curl is required to install the Nerd Font."
  command -v sha256sum >/dev/null 2>&1 || die "sha256sum is required to verify the Nerd Font."

  base_url="https://github.com/ryanoasis/nerd-fonts/releases/download/$version"
  new_temp_dir
  log "Downloading and verifying JetBrainsMono Nerd Font $version"
  curl -fsSL "$base_url/JetBrainsMono.tar.xz" -o "$TEMP_DIR/JetBrainsMono.tar.xz"
  curl -fsSL "$base_url/SHA-256.txt" -o "$TEMP_DIR/SHA-256.txt"
  checksum=$(awk '$2 == "JetBrainsMono.tar.xz" || $2 == "*JetBrainsMono.tar.xz" { print $1; exit }' "$TEMP_DIR/SHA-256.txt")
  [[ "$checksum" =~ ^[a-fA-F0-9]{64}$ ]] || die "Could not find the Nerd Font checksum."
  printf '%s  %s\n' "$checksum" "$TEMP_DIR/JetBrainsMono.tar.xz" | sha256sum -c -

  font_dir="$TARGET_HOME/.local/share/fonts/JetBrainsMonoNerd"
  mkdir -p "$font_dir"
  tar -xJf "$TEMP_DIR/JetBrainsMono.tar.xz" -C "$font_dir"
  if command -v fc-cache >/dev/null 2>&1; then
    fc-cache -f "$font_dir" >/dev/null
  fi
}

ensure_backup_dir() {
  if [[ -z "$BACKUP_DIR" ]]; then
    BACKUP_DIR="$TARGET_HOME/.dotfiles-backup/$(date +%Y%m%d-%H%M%S)-$$"
    run mkdir -p "$BACKUP_DIR"
    log "Conflicting files will be backed up to $BACKUP_DIR"
  fi
}

link_config() {
  local source=$1 target=$2 relative=$3 backup_target

  [[ -e "$source" ]] || die "Missing repository file: $source"
  run mkdir -p "$(dirname -- "$target")"

  if [[ -L "$target" && "$(readlink -- "$target")" == "$source" ]]; then
    log "Already linked: $target"
    return
  fi

  if [[ -e "$target" || -L "$target" ]]; then
    ensure_backup_dir
    backup_target="$BACKUP_DIR/$relative"
    run mkdir -p "$(dirname -- "$backup_target")"
    run mv -- "$target" "$backup_target"
    log "Backed up: $target"
  fi

  run ln -s -- "$source" "$target"
  log "Linked: $target -> $source"
}

install_config_links() {
  run mkdir -p "$TARGET_HOME/.config" "$TARGET_HOME/.local/bin" "$TARGET_HOME/.ssh"
  run chmod 700 "$TARGET_HOME/.ssh"

  link_config "$SCRIPT_DIR/bash/.bashrc" "$TARGET_HOME/.bashrc" .bashrc
  link_config "$SCRIPT_DIR/bash/.profile" "$TARGET_HOME/.profile" .profile
  link_config "$SCRIPT_DIR/git/.gitconfig" "$TARGET_HOME/.gitconfig" .gitconfig
  link_config "$SCRIPT_DIR/kitty" "$TARGET_HOME/.config/kitty" .config/kitty
  link_config "$SCRIPT_DIR/nvim" "$TARGET_HOME/.config/nvim" .config/nvim
  link_config "$SCRIPT_DIR/tmux/.tmux.conf" "$TARGET_HOME/.tmux.conf" .tmux.conf
  link_config "$SCRIPT_DIR/zsh/.zshrc" "$TARGET_HOME/.zshrc" .zshrc
  link_config "$SCRIPT_DIR/zsh/.zprofile" "$TARGET_HOME/.zprofile" .zprofile

  run mkdir -p "$TARGET_HOME/.local/share/nvim/site/spell"
}

install_vscode_extensions() {
  local manifest=$SCRIPT_DIR/vscode/extensions.txt line extension

  if ! command -v code >/dev/null 2>&1; then
    log "VS Code is not installed; extension restoration was skipped"
    return
  fi

  while IFS= read -r line || [[ -n "$line" ]]; do
    line=${line%%#*}
    extension=$(trim "$line")
    [[ -z "$extension" ]] && continue
    [[ "$extension" =~ ^[A-Za-z0-9][A-Za-z0-9._-]*$ ]] ||
      die "Invalid VS Code extension entry: $extension"
    run code --install-extension "$extension" --force
  done <"$manifest"
}

version_at_least() {
  local current=$1 required=$2 first
  first=$(printf '%s\n%s\n' "$required" "$current" | sort -V | head -n 1)
  [[ "$first" == "$required" ]]
}

sync_neovim_plugins() {
  local nvim_bin version

  hash -r
  nvim_bin=$(command -v nvim || true)
  [[ -n "$nvim_bin" ]] || die "Neovim was not found after package installation."
  version=$($nvim_bin --version | awk 'NR == 1 { sub(/^v/, "", $2); print $2 }')
  version_at_least "$version" 0.11.0 ||
    die "This config requires Neovim 0.11 or newer; found $version at $nvim_bin."

  if ((DRY_RUN)); then
    print_command "$nvim_bin" --headless '+Lazy! restore' +qa
    return
  fi

  log "Restoring Neovim plugins from lazy-lock.json (the first run can take a few minutes)"
  "$nvim_bin" --headless '+Lazy! restore' +qa
}

change_login_shell() {
  local zsh_path
  zsh_path=$(command -v zsh || true)
  [[ -n "$zsh_path" ]] || die "Zsh is not installed."
  [[ "${SHELL:-}" == "$zsh_path" ]] && { log "Zsh is already the login shell"; return; }
  run chsh -s "$zsh_path"
}

for arg in "$@"; do
  case "$arg" in
    --dry-run) DRY_RUN=1 ;;
    --no-packages) INSTALL_PACKAGES=0 ;;
    --no-extras) INSTALL_EXTRAS=0 ;;
    --no-neovim-sync) SYNC_NEOVIM=0 ;;
    --no-vscode) INSTALL_VSCODE_EXTENSIONS=0 ;;
    --change-shell) CHANGE_SHELL=1 ;;
    -h | --help) usage; exit 0 ;;
    *) die "Unknown option: $arg (use --help)" ;;
  esac
done

[[ "$(uname -s)" == Linux ]] || die "This installer supports Linux only."
((EUID != 0)) || die "Run this script as your normal user, not with sudo. It requests sudo only for system packages."
[[ "$TARGET_HOME" == /* && "$TARGET_HOME" != / ]] || die "The target home must be an absolute, non-root path."
[[ -f "$SCRIPT_DIR/README.md" && -d "$SCRIPT_DIR/nvim" ]] ||
  die "Run the installer from a complete copy of the dotfiles folder."

trap cleanup EXIT

if ((INSTALL_PACKAGES)); then
  install_apt_packages
  install_snap_packages
  install_flatpak_packages
fi

if ((INSTALL_EXTRAS)); then
  install_deno
  install_nerd_font
fi

install_config_links

((INSTALL_VSCODE_EXTENSIONS)) && install_vscode_extensions
((SYNC_NEOVIM)) && sync_neovim_plugins
((CHANGE_SHELL)) && change_login_shell

log "Installation complete. Open a new terminal to load the shell configuration."
if ((CHANGE_SHELL == 0)); then
  log "Optional: run './install.sh --no-packages --no-extras --no-neovim-sync --change-shell' to make Zsh your login shell."
fi
log "SSH keys, GitHub/Copilot sign-in, and API credentials are intentionally not copied; see README.md."
