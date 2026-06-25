#!/usr/bin/env bash

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_URL="${DOTFILES_REPO_URL:-}"
TARGET_DIR="${DOTFILES_DIR:-$HOME/.dotfiles}"

if [[ -f "$ROOT_DIR/scripts/bootstrap.sh" ]]; then
    exec "$ROOT_DIR/scripts/bootstrap.sh" "$@"
fi

if [[ -z "$REPO_URL" ]]; then
    cat <<'EOF' >&2
DOTFILES_REPO_URL is not set.
Clone the repository first or export DOTFILES_REPO_URL before running bootstrap.
EOF
    exit 1
fi

if ! command -v git >/dev/null 2>&1; then
    if command -v apt-get >/dev/null 2>&1; then
        sudo apt-get update
        sudo DEBIAN_FRONTEND=noninteractive apt-get install -y git curl ca-certificates
    else
        echo "git is required to clone the repository." >&2
        exit 1
    fi
fi

if [[ ! -d "$TARGET_DIR/.git" ]]; then
    rm -rf "$TARGET_DIR"
    git clone "$REPO_URL" "$TARGET_DIR"
fi

exec "$TARGET_DIR/scripts/bootstrap.sh" "$@"