#!/usr/bin/env bash
#
# install.sh - Fresh-device entrypoint for the dotfiles setup.
#
# Kept intentionally small: make sure the base tools needed to obtain and run
# the repository exist (git, curl, ca-certificates), then forward everything
# else to bootstrap.sh, which clones (if needed) and builds the environment.
#
# Usage:
#   bash install.sh                              # ~/.dotfiles + default repo URL
#   DOTFILES_DIR=/opt/dotfiles bash install.sh   # custom target directory
#   DOTFILES_REPO_URL=... bash install.sh        # custom repo URL
#   bash install.sh --no-build                   # link configs but skip Neovim build
#
set -Eeuo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

have() { command -v "$1" >/dev/null 2>&1; }

# --- ensure base tooling ---------------------------------------------------
# Cloning (and the restore flow) needs git. Curl is used by several plugin
# bootstrappers. Install them on Debian/Ubuntu if they are missing.
if ! have git || ! have curl; then
    if have apt-get; then
        echo "[install] git/curl missing - installing base tools via apt..."
        if [[ ${EUID:-$(id -u)} -eq 0 ]]; then
            apt-get update
            DEBIAN_FRONTEND=noninteractive apt-get install -y git curl ca-certificates
        else
            sudo apt-get update
            sudo env DEBIAN_FRONTEND=noninteractive apt-get install -y git curl ca-certificates
        fi
    else
        echo "[install] ERROR: git and curl are required but not found." >&2
        echo "[install] Install them for your OS, then re-run install.sh." >&2
        exit 1
    fi
fi

exec "$ROOT_DIR/bootstrap.sh" "$@"
