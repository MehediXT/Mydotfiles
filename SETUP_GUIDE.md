# MyDotfiles — Setup Guide

Transform a fresh Ubuntu/Debian machine into a complete development environment with one command.

This repository tracks personal configuration for:

- Neovim (Lazy.nvim, Aylin theme)
- Kitty terminal
- Bash and Zsh
- Git, tmux, VS Code extensions
- Competitive programming helpers (`cpnew`)
- APT, Snap, and Flatpak package manifests

For backup, restore, security rules, and maintenance details, see [README.md](README.md).

---

## Quick Start

### 1. Clone the repository

```bash
git clone https://github.com/MehediXT/Mydotfiles.git ~/.dotfiles
cd ~/.dotfiles
```

### 2. Run the installer

```bash
bash install.sh
```

Or, if the script is executable:

```bash
chmod +x install.sh
./install.sh
```

### 3. Reload your shell

```bash
source ~/.bashrc
```

---

## What the Installer Does

`install.sh` is a compatibility entrypoint that forwards to `bootstrap.sh`.

The bootstrap flow runs `scripts/restore.sh`, which:

1. Installs packages from `packages/apt.txt`, `packages/snap.txt`, and `packages/flatpak.txt`
2. Adds the Neovim stable PPA when needed (Ubuntu's default Neovim is too old for this config)
3. Symlinks tracked configs into `$HOME`:
   - Bash (`.bashrc`, `.profile`)
   - Zsh (`.zshrc`, `.zprofile`)
   - Git (`.gitconfig`)
   - Kitty (`~/.config/kitty`)
   - Neovim (`~/.config/nvim`)
   - tmux (`~/.tmux.conf`)
   - `cpnew` helper (`~/.local/bin/cpnew`)
4. Installs VS Code extensions from `vscode/extensions.txt` when `code` is available

Existing files are moved to `~/.local/state/dotfiles/pre-restore/` before linking — nothing is deleted.

---

## Post Installation

### Initialize Neovim

Launch Neovim for the first time:

```bash
nvim
```

On first launch, Lazy.nvim will:

- Download and install plugins
- Compile Tree-sitter parsers
- Apply the Aylin theme

Wait until installation reaches **100%**, then exit with `:q` and reopen:

```bash
nvim
```

### Set Zsh as your default shell (optional)

```bash
chsh -s "$(which zsh)"
```

Log out and back in for the change to take effect.

### Update Git identity

Edit `git/.gitconfig` with your name and email before committing:

```bash
nvim ~/.dotfiles/git/.gitconfig
```

Then re-run restore or manually symlink if needed:

```bash
bash scripts/restore.sh
```

---

## Optional: Restore From a Backup Snapshot

If you have a machine snapshot from `scripts/backup.sh`:

```bash
bash scripts/restore.sh --snapshot /path/to/snapshot
```

This restores snapshot-specific SSH config, VS Code settings, and package lists on top of the tracked dotfiles.

---

## Troubleshooting

### Installer finishes instantly with no changes

Make sure you are inside the repository:

```bash
cd ~/.dotfiles
bash install.sh
```

Prefer `bash install.sh` or `./install.sh` from the repo root so paths resolve correctly.

### Symbolic links were not created

The restore script creates `~/.config` and other parent directories automatically. Re-run:

```bash
bash scripts/restore.sh
```

### Neovim Tree-sitter errors

Tree-sitter needs a C compiler. It is included in `packages/apt.txt` as `build-essential`. If missing:

```bash
sudo apt install build-essential
```

Then reopen Neovim.

### Plugins fail to install

Check your internet connection, then inside Neovim:

```vim
:Lazy sync
```

### Verify installed versions

```bash
git --version
nvim --version
kitty --version
zsh --version
tmux -V
```

Neovim should be **0.9+** for this configuration.

---

## Repository Structure

```text
~/.dotfiles/
├── install.sh              # Entrypoint (forwards to bootstrap)
├── bootstrap.sh            # Top-level bootstrap
├── README.md               # Full documentation
├── SETUP_GUIDE.md          # This file
├── bash/                   # Bash shell config
├── zsh/                    # Zsh shell config
├── git/                    # Git defaults
├── kitty/                  # Kitty terminal
├── nvim/                   # Neovim + Lazy.nvim
├── tmux/                   # tmux config
├── cp/                     # Competitive programming tools
├── packages/               # APT, Snap, Flatpak manifests
├── scripts/                # backup.sh, restore.sh, common helpers
├── ssh/                    # Example SSH config (no private keys)
└── vscode/                 # VS Code extension list
```

---

## Useful Commands

```bash
# Create a new competitive programming file
cpnew solution.cpp

# Back up current machine state
bash scripts/backup.sh

# Re-apply tracked configs and packages
bash scripts/restore.sh

# Reinstall VS Code extensions only (after restore)
bash scripts/restore.sh
```

---

Personal dotfiles maintained by **MehediXT**. Fork and adapt to your own workflow.
