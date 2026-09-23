#!/usr/bin/env bash

set -Eeuo pipefail

readonly REPO_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)"
readonly MIN_NVIM_VERSION="0.12.0"
readonly MIN_TREE_SITTER_VERSION="0.26.1"

export PATH="$HOME/.local/bin:$PATH"

DRY_RUN=false
INSTALL_PACKAGES=true
INSTALL_SHELL_EXTRAS=true
BOOTSTRAP_NVIM=true
SETUP_VSCODE=true
CHANGE_SHELL=false
BACKUP_ROOT="${DOTFILES_BACKUP_DIR:-$HOME/.dotfiles-backup/$(date +%Y%m%d-%H%M%S)-$$}"
declare -a ISSUES=()
declare -a TEMP_DIRS=()

usage() {
  cat <<'EOF'
Usage: ./setup.sh [options]

Set up these dotfiles on an Ubuntu/Debian machine. Existing files are moved
to a timestamped backup directory before symlinks are created.

Options:
  --dry-run             Print actions without changing anything
  --skip-packages       Do not install APT, Snap, or Flatpak packages
  --skip-shell-extras   Do not install Oh My Zsh, Spaceship, or Zsh plugins
  --skip-neovim         Do not bootstrap Neovim plugins, parsers, and tools
  --skip-vscode         Do not link VS Code settings or install extensions
  --change-shell        Change the login shell to Zsh
  -h, --help            Show this help

Environment:
  DOTFILES_BACKUP_DIR   Override the backup directory
EOF
}

info() {
  printf '\033[1;34m[INFO]\033[0m %s\n' "$*"
}

ok() {
  printf '\033[1;32m[ OK ]\033[0m %s\n' "$*"
}

warn() {
  printf '\033[1;33m[WARN]\033[0m %s\n' "$*" >&2
}

die() {
  printf '\033[1;31m[FAIL]\033[0m %s\n' "$*" >&2
  exit 1
}

issue() {
  ISSUES+=("$*")
  warn "$*"
}

print_command() {
  printf '  +'
  printf ' %q' "$@"
  printf '\n'
}

run() {
  if "$DRY_RUN"; then
    print_command "$@"
    return 0
  fi

  "$@"
}

cleanup() {
  local directory
  for directory in "${TEMP_DIRS[@]}"; do
    [[ -d "$directory" ]] && rm -rf -- "$directory"
  done
}
trap cleanup EXIT

while (($# > 0)); do
  case "$1" in
    --dry-run) DRY_RUN=true ;;
    --skip-packages) INSTALL_PACKAGES=false ;;
    --skip-shell-extras) INSTALL_SHELL_EXTRAS=false ;;
    --skip-neovim) BOOTSTRAP_NVIM=false ;;
    --skip-vscode) SETUP_VSCODE=false ;;
    --change-shell) CHANGE_SHELL=true ;;
    -h | --help)
      usage
      exit 0
      ;;
    *)
      usage >&2
      die "Unknown option: $1"
      ;;
  esac
  shift
done

[[ "$(uname -s)" == "Linux" ]] || die "This installer currently supports Linux only."
((EUID != 0)) || die "Run this script as your normal user, not with sudo."

version_at_least() {
  local current="$1"
  local minimum="$2"
  [[ "$(printf '%s\n%s\n' "$minimum" "$current" | sort -V | head -n 1)" == "$minimum" ]]
}

read_manifest() {
  local manifest="$1"
  local line

  while IFS= read -r line || [[ -n "$line" ]]; do
    line="${line%%#*}"
    line="${line#"${line%%[![:space:]]*}"}"
    line="${line%"${line##*[![:space:]]}"}"
    [[ -n "$line" ]] && printf '%s\n' "$line"
  done < "$manifest"
}

install_system_packages() {
  "$INSTALL_PACKAGES" || return 0

  command -v apt-get >/dev/null 2>&1 || {
    issue "APT is unavailable. Re-run with --skip-packages and install dependencies for your distribution manually."
    return
  }
  command -v sudo >/dev/null 2>&1 || die "sudo is required to install system packages."

  local -a apt_packages=()
  mapfile -t apt_packages < <(read_manifest "$REPO_DIR/packages/apt.txt")

  info "Installing ${#apt_packages[@]} APT packages"
  run sudo apt-get update
  run sudo env DEBIAN_FRONTEND=noninteractive apt-get install -y "${apt_packages[@]}"

  install_snap_packages
  install_flatpak_packages
}

install_snap_packages() {
  local manifest="$REPO_DIR/packages/snap.txt"
  local entry name flags

  [[ -s "$manifest" ]] || return 0
  if ! command -v snap >/dev/null 2>&1; then
    issue "snap is unavailable; packages from packages/snap.txt were skipped."
    return
  fi

  while IFS= read -r entry; do
    IFS='|' read -r name flags <<< "$entry"
    if snap list "$name" >/dev/null 2>&1; then
      ok "Snap already installed: $name"
      continue
    fi

    local -a command=(sudo snap install "$name")
    [[ "$flags" == "classic" ]] && command+=(--classic)
    if ! run "${command[@]}"; then
      issue "Could not install Snap package: $name"
    fi
  done < <(read_manifest "$manifest")
}

install_flatpak_packages() {
  local manifest="$REPO_DIR/packages/flatpak.txt"
  local entry app remote

  [[ -s "$manifest" ]] || return 0
  command -v flatpak >/dev/null 2>&1 || {
    issue "flatpak is unavailable; packages from packages/flatpak.txt were skipped."
    return
  }

  while IFS= read -r entry; do
    IFS='|' read -r app remote <<< "$entry"
    remote="${remote:-flathub}"
    if flatpak info "$app" >/dev/null 2>&1; then
      ok "Flatpak already installed: $app"
    elif ! run flatpak install -y "$remote" "$app"; then
      issue "Could not install Flatpak package: $app"
    fi
  done < <(read_manifest "$manifest")
}

backup_and_link() {
  local source="$1"
  local target="$2"
  local existing_target=""

  if [[ ! -e "$source" ]] && ! "$DRY_RUN"; then
    die "Link source does not exist: $source"
  fi

  if [[ -L "$target" ]]; then
    existing_target="$(readlink -f -- "$target" 2>/dev/null || true)"
    if [[ "$existing_target" == "$(readlink -f -- "$source")" ]]; then
      ok "Already linked: $target"
      return
    fi
  fi

  backup_existing "$target"

  run mkdir -p -- "$(dirname -- "$target")"
  run ln -s -- "$source" "$target"
  ok "Linked $target"
}

backup_existing() {
  local target="$1"
  [[ -e "$target" || -L "$target" ]] || return 0
  [[ "$target" == "$HOME"/* ]] || die "Refusing to back up a path outside HOME: $target"

  local relative="${target#"$HOME"/}"
  local backup="$BACKUP_ROOT/$relative"
  info "Backing up $target to $backup"
  run mkdir -p -- "$(dirname -- "$backup")"
  run mv -- "$target" "$backup"
}

link_dotfiles() {
  info "Creating dotfile symlinks"

  local entry source target
  local -a links=(
    ".config/nvim|$HOME/.config/nvim"
    ".config/kitty|$HOME/.config/kitty"
    ".config/hypr|$HOME/.config/hypr"
    ".config/neofetch|$HOME/.config/neofetch"
    ".config/wayscriber|$HOME/.config/wayscriber"
    "bash/.bashrc|$HOME/.bashrc"
    "bash/.profile|$HOME/.profile"
    "zsh/.zshrc|$HOME/.zshrc"
    "zsh/.zprofile|$HOME/.zprofile"
    "tmux/.tmux.conf|$HOME/.tmux.conf"
    "git/.gitconfig|$HOME/.gitconfig"
  )

  for entry in "${links[@]}"; do
    IFS='|' read -r source target <<< "$entry"
    backup_and_link "$REPO_DIR/$source" "$target"
  done
}

install_zip_binary() {
  local name="$1"
  local url="$2"
  local archive_binary="$3"
  local destination="$HOME/.local/bin/$name"

  info "Installing $name from its official release archive"
  if "$DRY_RUN"; then
    print_command curl -fL "$url" -o "/tmp/$name.zip"
    print_command unzip -q "/tmp/$name.zip" -d "/tmp/$name"
    print_command install -Dm755 "/tmp/$name/$archive_binary" "$destination"
    return
  fi

  local temp_dir
  temp_dir="$(mktemp -d)"
  TEMP_DIRS+=("$temp_dir")
  curl -fL "$url" -o "$temp_dir/archive.zip"
  unzip -q "$temp_dir/archive.zip" -d "$temp_dir/extracted"

  local binary="$temp_dir/extracted/$archive_binary"
  [[ -f "$binary" ]] || die "$name archive did not contain $archive_binary"
  install -Dm755 "$binary" "$destination"
}

install_tree_sitter_cli() {
  local current=""
  if command -v tree-sitter >/dev/null 2>&1; then
    current="$(tree-sitter --version 2>/dev/null | sed -En 's/.* ([0-9]+\.[0-9]+\.[0-9]+).*/\1/p' | head -n 1)"
  fi
  if [[ -n "$current" ]] && version_at_least "$current" "$MIN_TREE_SITTER_VERSION"; then
    ok "tree-sitter CLI $current satisfies >= $MIN_TREE_SITTER_VERSION"
    return
  fi

  local asset_arch
  case "$(uname -m)" in
    x86_64) asset_arch="x64" ;;
    aarch64 | arm64) asset_arch="arm64" ;;
    armv7l | armv6l) asset_arch="arm" ;;
    *)
      issue "Unsupported architecture for automatic tree-sitter CLI installation: $(uname -m)"
      return
      ;;
  esac

  install_zip_binary \
    tree-sitter \
    "https://github.com/tree-sitter/tree-sitter/releases/latest/download/tree-sitter-cli-linux-${asset_arch}.zip" \
    tree-sitter
}

install_neovim() {
  local current=""
  if command -v nvim >/dev/null 2>&1; then
    current="$(nvim --version | sed -En '1s/.*v([0-9]+\.[0-9]+\.[0-9]+).*/\1/p')"
  fi
  if [[ -n "$current" ]] && version_at_least "$current" "$MIN_NVIM_VERSION"; then
    ok "Neovim $current satisfies >= $MIN_NVIM_VERSION"
    return
  fi

  local asset_arch
  case "$(uname -m)" in
    x86_64) asset_arch="x86_64" ;;
    aarch64 | arm64) asset_arch="arm64" ;;
    *)
      issue "Unsupported architecture for automatic Neovim installation: $(uname -m)"
      return
      ;;
  esac

  local url="https://github.com/neovim/neovim/releases/latest/download/nvim-linux-${asset_arch}.tar.gz"
  local install_dir="$HOME/.local/opt/nvim"
  info "Installing Neovim >= $MIN_NVIM_VERSION from its official release archive"

  if "$DRY_RUN"; then
    print_command curl -fL "$url" -o /tmp/nvim.tar.gz
    print_command tar -xzf /tmp/nvim.tar.gz -C /tmp
    backup_existing "$install_dir"
    print_command mkdir -p "$HOME/.local/opt"
    print_command mv "/tmp/nvim-linux-${asset_arch}" "$install_dir"
    backup_and_link "$install_dir/bin/nvim" "$HOME/.local/bin/nvim"
    return
  fi

  local temp_dir
  temp_dir="$(mktemp -d)"
  TEMP_DIRS+=("$temp_dir")
  curl -fL "$url" -o "$temp_dir/nvim.tar.gz"
  tar -xzf "$temp_dir/nvim.tar.gz" -C "$temp_dir"

  local extracted="$temp_dir/nvim-linux-${asset_arch}"
  [[ -x "$extracted/bin/nvim" ]] || die "The Neovim archive has an unexpected layout."
  backup_existing "$install_dir"
  mkdir -p "$HOME/.local/opt"
  mv "$extracted" "$install_dir"
  backup_and_link "$install_dir/bin/nvim" "$HOME/.local/bin/nvim"
  hash -r

  current="$(nvim --version | sed -En '1s/.*v([0-9]+\.[0-9]+\.[0-9]+).*/\1/p')"
  [[ -n "$current" ]] && version_at_least "$current" "$MIN_NVIM_VERSION" \
    || die "Installed Neovim does not satisfy >= $MIN_NVIM_VERSION."
}

install_deno() {
  if command -v deno >/dev/null 2>&1; then
    ok "Deno is already installed: $(deno --version | head -n 1)"
    return
  fi

  local target
  case "$(uname -m)" in
    x86_64) target="x86_64-unknown-linux-gnu" ;;
    aarch64 | arm64) target="aarch64-unknown-linux-gnu" ;;
    *)
      issue "Unsupported architecture for automatic Deno installation: $(uname -m)"
      return
      ;;
  esac

  install_zip_binary \
    deno \
    "https://github.com/denoland/deno/releases/latest/download/deno-${target}.zip" \
    deno
}

install_nerd_font() {
  if command -v fc-list >/dev/null 2>&1 && fc-list : family | grep -Fqi "AtkynsonMono Nerd Font"; then
    ok "AtkynsonMono Nerd Font is already installed"
    return
  fi

  info "Installing AtkynsonMono Nerd Font"
  local url="https://github.com/ryanoasis/nerd-fonts/releases/latest/download/AtkinsonHyperlegibleMono.zip"
  local font_dir="$HOME/.local/share/fonts/AtkynsonMonoNerdFont"

  if "$DRY_RUN"; then
    print_command curl -fL "$url" -o /tmp/AtkynsonMono.zip
    print_command unzip -q /tmp/AtkynsonMono.zip -d "$font_dir"
    print_command fc-cache -f "$font_dir"
    return
  fi

  local temp_dir
  temp_dir="$(mktemp -d)"
  TEMP_DIRS+=("$temp_dir")
  curl -fL "$url" -o "$temp_dir/font.zip"
  mkdir -p "$font_dir"
  unzip -q "$temp_dir/font.zip" -d "$font_dir"
  fc-cache -f "$font_dir" >/dev/null
}

clone_if_missing() {
  local repository="$1"
  local destination="$2"

  if [[ -d "$destination/.git" ]]; then
    ok "Already installed: $destination"
  elif [[ -e "$destination" ]]; then
    issue "$destination exists but is not a Git checkout; leaving it untouched."
  else
    run mkdir -p -- "$(dirname -- "$destination")"
    run git clone --depth=1 "$repository" "$destination"
  fi
}

install_shell_extras() {
  "$INSTALL_SHELL_EXTRAS" || return 0

  info "Installing Zsh framework, theme, and plugins"
  clone_if_missing https://github.com/ohmyzsh/ohmyzsh.git "$HOME/.oh-my-zsh"

  local custom="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"
  clone_if_missing https://github.com/spaceship-prompt/spaceship-prompt.git "$custom/themes/spaceship-prompt"
  backup_and_link \
    "$custom/themes/spaceship-prompt/spaceship.zsh-theme" \
    "$custom/themes/spaceship.zsh-theme"
  clone_if_missing https://github.com/zsh-users/zsh-autosuggestions.git "$custom/plugins/zsh-autosuggestions"
  clone_if_missing https://github.com/zsh-users/zsh-syntax-highlighting.git "$custom/plugins/zsh-syntax-highlighting"

  if "$CHANGE_SHELL"; then
    local zsh_path
    zsh_path="$(command -v zsh || true)"
    [[ -n "$zsh_path" ]] || {
      issue "Zsh is unavailable; the login shell was not changed."
      return
    }
    if [[ "${SHELL:-}" == "$zsh_path" ]]; then
      ok "Zsh is already the login shell"
    else
      run chsh -s "$zsh_path"
    fi
  fi
}

create_fd_compatibility_link() {
  command -v fd >/dev/null 2>&1 && return 0
  local fdfind
  fdfind="$(command -v fdfind || true)"
  [[ -n "$fdfind" ]] || return 0
  backup_and_link "$fdfind" "$HOME/.local/bin/fd"
}

setup_vscode() {
  "$SETUP_VSCODE" || return 0
  if ! command -v code >/dev/null 2>&1; then
    warn "VS Code CLI not found; settings and extensions were skipped."
    return
  fi

  info "Setting up VS Code"
  local user_dir="$HOME/.config/Code/User"
  backup_and_link "$REPO_DIR/vscode/settings.json" "$user_dir/settings.json"
  backup_and_link "$REPO_DIR/vscode/keybindings.json" "$user_dir/keybindings.json"

  local extension
  while IFS= read -r extension; do
    if ! run code --install-extension "$extension"; then
      issue "Could not install VS Code extension: $extension"
    fi
  done < <(read_manifest "$REPO_DIR/vscode/extensions.txt")
}

bootstrap_neovim() {
  "$BOOTSTRAP_NVIM" || return 0
  if ! command -v nvim >/dev/null 2>&1; then
    issue "Neovim is unavailable; plugin bootstrap was skipped."
    return
  fi

  local version
  version="$(nvim --version | sed -En '1s/.*v([0-9]+\.[0-9]+\.[0-9]+).*/\1/p')"
  if [[ -z "$version" ]] || ! version_at_least "$version" "$MIN_NVIM_VERSION"; then
    issue "Neovim $version is too old; this configuration requires >= $MIN_NVIM_VERSION."
    return
  fi

  info "Bootstrapping Neovim $version (this can take several minutes)"
  if ! run nvim --headless "+Lazy! sync" +qa; then
    issue "lazy.nvim could not finish synchronizing plugins."
    return
  fi

  local treesitter_command
  treesitter_command="lua local langs=require('configs.treesitter').ensure_installed; assert(require('nvim-treesitter').install(langs, {summary=true, max_jobs=4}):wait(600000))"
  if ! run nvim --headless "+$treesitter_command" +qa; then
    issue "Treesitter parsers did not finish installing."
  fi

  if ! run nvim --headless "+MasonToolsInstallSync" +qa; then
    issue "Mason tools did not finish installing."
  fi
}

print_summary() {
  printf '\n'
  if "$DRY_RUN"; then
    info "Dry run complete; no changes were made."
  else
    ok "Dotfile setup complete."
    [[ -d "$BACKUP_ROOT" ]] && info "Previous files were saved in $BACKUP_ROOT"
  fi

  if ((${#ISSUES[@]} > 0)); then
    warn "Completed with ${#ISSUES[@]} warning(s):"
    local message
    for message in "${ISSUES[@]}"; do
      printf '  - %s\n' "$message" >&2
    done
  fi

  printf '\nNext steps:\n'
  printf '  1. Restart the terminal, then start Neovim a second time.\n'
  printf '  2. In Neovim, run :checkhealth nvim-treesitter and :LspInfo.\n'
  printf '  3. Review .config/hypr/monitors.lua and startup.lua for this machine.\n'
  printf '  4. Restore SSH keys, Copilot login, Ollama models, and other credentials manually.\n'
}

main() {
  info "Repository: $REPO_DIR"
  info "Backups:    $BACKUP_ROOT"

  install_system_packages
  install_neovim
  link_dotfiles
  install_tree_sitter_cli
  install_deno
  install_nerd_font
  install_shell_extras
  create_fd_compatibility_link
  setup_vscode
  bootstrap_neovim
  print_summary
}

main "$@"
