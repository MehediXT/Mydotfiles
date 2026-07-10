#!/usr/bin/env bash
#
# bootstrap.sh - Clone (if necessary) and build the full dotfiles environment
#                on a new machine. This is the orchestrator that install.sh
#                forwards to.
#
# It does four things:
#   1. Decides whether the full repository is already present (cloned or copied).
#   2. If only this script was copied, clones the full repo, then re-execs it.
#   3. Runs the restore flow (packages + symlinks) via scripts/restore.sh.
#   4. Builds the runtime environment (Neovim plugins + treesitter, optional
#      zsh default shell) and prints a short environment check.
#
# Options:
#   --target DIR          Clone/use the repo here        (default: ~/.dotfiles)
#   --url URL             Repo URL to clone               (default below)
#   --no-build            Skip the Neovim plugin/treesitter build
#   --set-zsh             Make zsh the default login shell
#   --clean-nested-git    Remove nested .git dirs (see NOTES). Never use on the
#                         source machine - only on a copied/rsync'd repo.
#   -h, --help            Show this help
#
# NOTES on "copying" this to another device:
#   * Preferred:  git clone <url> ~/.dotfiles && cd ~/.dotfiles && bash install.sh
#     A git clone never carries nested .git dirs, so it is always clean.
#   * If you copy with cp/rsync/tar instead, the nvim/ subtree has its own .git
#     (it is tracked by this repo AND kept as a separate repo). That nested .git
#     would land on the target and confuse git. Re-run with --clean-nested-git
#     (only on the COPIED repo, never the original) to strip nested .git dirs.
#
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Defaults. Override with env vars or the flags below.
DOTFILES_DIR="${DOTFILES_DIR:-$HOME/.dotfiles}"
DOTFILES_REPO_URL="${DOTFILES_REPO_URL:-https://github.com/MehediXT/Mydotfiles.git}"

DO_BUILD=1
SET_ZSH=0
CLEAN_NESTED_GIT=0

usage() {
    cat <<'EOF'
Usage: bash bootstrap.sh [options]

  --target DIR     Clone/use the repo at DIR        (default: ~/.dotfiles)
  --url URL        Repo URL to clone                 (default: DOTFILES_REPO_URL)
  --no-build       Skip the Neovim plugin/treesitter build
  --set-zsh        Make zsh the default login shell
  --clean-nested-git  Remove nested .git dirs on a copied repo (see header notes)
  -h, --help       Show this help
EOF
}

while [[ $# -gt 0 ]]; do
    case "$1" in
        --target) DOTFILES_DIR="$2"; shift 2 ;;
        --url)    DOTFILES_REPO_URL="$2"; shift 2 ;;
        --no-build) DO_BUILD=0; shift ;;
        --set-zsh)  SET_ZSH=1; shift ;;
        --clean-nested-git) CLEAN_NESTED_GIT=1; shift ;;
        -h|--help) usage; exit 0 ;;
        *) echo "Unknown argument: $1" >&2; usage; exit 1 ;;
    esac
done

# --- helpers (inline so this works even on a sparse copy with no scripts/) ---
have() { command -v "$1" >/dev/null 2>&1; }
log_info() { printf '[bootstrap] %s\n' "$*"; }
log_warn() { printf '[bootstrap] %s\n' "$*" >&2; }

run_as_root() {
    if [[ ${EUID:-$(id -u)} -eq 0 ]]; then "$@"; else sudo "$@"; fi
}

# Find every nested .git directory (depth >= 2) under the repo root into an
# array. The top-level repo .git lives at depth 1, so it is never matched.
# mapfile of an empty find result yields a 0-element array, which is safe.
find_nested_git() {
    local dir="$1"
    shift
    mapfile -t "$@" < <(find "$dir" -mindepth 2 -name .git -type d -prune 2>/dev/null)
}

clean_nested_git() {
    local dir="$1" g
    local -a nested=()
    find_nested_git "$dir" nested
    if [[ ${#nested[@]} -eq 0 ]]; then
        return 0
    fi
    log_info "Removing nested .git directories so the target stays one clean repo:"
    for g in "${nested[@]}"; do
        [[ -z "$g" ]] && continue
        log_info "  removing $g"
        rm -rf "$g"
    done
}

warn_if_nested_git() {
    local dir="$1"
    local -a nested=()
    find_nested_git "$dir" nested
    if [[ ${#nested[@]} -eq 0 ]]; then
        return 0
    fi
    log_warn "Nested .git directory detected (e.g. ${nested[0]})."
    log_warn "This repo was likely copied with cp/rsync/tar. Re-run with"
    log_warn "--clean-nested-git (on the COPIED repo only) so the target is a single"
    log_warn "clean git repo. Skipping automatic removal to avoid touching the source."
}

run_restore() {
    log_info "Restoring tracked configuration and installing packages..."
    "$DOTFILES_ROOT/scripts/restore.sh"
}

build_neovim() {
    [[ $DO_BUILD -eq 1 ]] || { log_info "Build skipped (--no-build)."; return 0; }
    if ! have nvim; then
        log_warn "nvim not found; skipping build. Run the build after Neovim is installed."
        return 0
    fi

    log_info "Building Neovim environment (plugins + treesitter)... this may take a while"
    # LazySync / TSUpdateSync are the headless, non-interactive build commands.
    nvim --headless "+LazySync" "+qa" \
        || log_warn "Lazy sync reported errors; open nvim and run :Lazy sync"
    nvim --headless "+TSUpdateSync" "+qa" || true
    log_info "Neovim build finished."
}

maybe_set_zsh() {
    [[ $SET_ZSH -eq 1 ]] || return 0
    if ! have zsh; then
        log_warn "zsh not installed; skipping chsh."
        return 0
    fi
    local zsh_bin
    zsh_bin="$(command -v zsh)"
    if grep -qx "$zsh_bin" /etc/shells; then
        if chsh -s "$zsh_bin"; then
            log_info "Default shell set to zsh. Log out and back in to apply."
        else
            log_warn "chsh failed; run 'chsh -s $zsh_bin' manually."
        fi
    else
        log_warn "$zsh_bin is not listed in /etc/shells; skipping chsh."
    fi
}

verify() {
    log_info "Environment check:"
    local c out
    for c in git nvim zsh tmux kitty; do
        if have "$c"; then
            out="$("$c" --version 2>/dev/null | head -1)"
            printf '  %-8s %s\n' "$c" "${out:-installed}"
        else
            printf '  %-8s (not installed)\n' "$c"
        fi
    done
}

# --- Path A: the full repo is already here (cloned or copied) --------------
if [[ -f "$ROOT_DIR/scripts/restore.sh" ]]; then
    DOTFILES_ROOT="$ROOT_DIR"

    if [[ $CLEAN_NESTED_GIT -eq 1 ]]; then
        clean_nested_git "$DOTFILES_ROOT"
    else
        warn_if_nested_git "$DOTFILES_ROOT"
    fi

    run_restore
    build_neovim
    maybe_set_zsh
    verify
    log_info "Done. Reload your shell: exec \$SHELL -l"
    exit 0
fi

# --- Path B: only this script was copied - clone the full repo, then re-exec
log_info "Full repository not found here; cloning $DOTFILES_REPO_URL -> $DOTFILES_DIR"

if ! have git; then
    echo "[bootstrap] ERROR: git is required to clone the repository." >&2
    exit 1
fi

if [[ -d "$DOTFILES_DIR/.git" ]]; then
    log_info "Target is already a git repo; updating..."
    git -C "$DOTFILES_DIR" pull --ff-only || log_warn "git pull failed; continuing with existing clone."
elif [[ -e "$DOTFILES_DIR" ]]; then
    log_warn "$DOTFILES_DIR exists but is not a git repo; aborting to avoid clobbering it."
    exit 1
else
    git clone "$DOTFILES_REPO_URL" "$DOTFILES_DIR"
fi

# The cloned repo has its own bootstrap.sh; run that (with the same args) so the
# full restore + build runs from the real checkout.
exec "$DOTFILES_DIR/bootstrap.sh" "$@"
