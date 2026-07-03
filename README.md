# Dotfiles + System Setup

This repository is a portable Ubuntu-first workstation bootstrap for shell, terminal, editor, Git, SSH, tmux, VS Code, and package state. It is designed to recreate a development environment on a new machine with minimal manual work while keeping secrets out of version control.

## Repository Structure

```text
dotfiles/
├── bootstrap.sh
├── install.sh
├── README.md
├── .gitignore
├── bash/
├── cp/
├── git/
├── kitty/
├── nvim/
├── packages/
├── scripts/
├── ssh/
├── tmux/
├── vscode/
└── zsh/
```

## What Each Area Does

- `bash/`: Bash login and interactive shell configuration.
- `zsh/`: Portable Zsh configuration for future migration or WSL.
- `git/`: Git defaults, aliases, editor settings, and identity fields.
- `kitty/`: Kitty terminal configuration and theme fragments.
- `nvim/`: Full Neovim configuration and plugin setup.
- `tmux/`: tmux behavior, keybindings, and pane defaults.
- `ssh/`: Tracked example only; never commit private keys.
- `vscode/`: Extension inventory used during restore.
- `cp/`: Competitive programming helper scripts and templates.
- `packages/`: Package manifests for APT, Snap, and Flatpak.
- `scripts/`: Backup, restore, bootstrap, and shared shell helpers.

## Core Commands

### Fresh local install after cloning

```bash
cd ~/.dotfiles
bash install.sh
```

Install VS Code separately if you want the extension restore step to run.

### Backup the current machine

```bash
bash scripts/backup.sh
```

### Restore the tracked setup

```bash
bash scripts/restore.sh
```

### Restore from a snapshot

```bash
bash scripts/restore.sh --snapshot /path/to/snapshot
```

## Bootstrap Flow

`install.sh` is a compatibility wrapper that forwards to `bootstrap.sh`.

`bootstrap.sh` is the top-level entrypoint for a fresh machine. It delegates to `scripts/bootstrap.sh`, which in turn runs the restore flow. In normal use, clone the repository first and then run `bash install.sh`.

## Backup Behavior

The backup script captures machine-specific state into timestamped snapshots under `backups/<host>/<timestamp>/`.

Included:

- Bash, Zsh, Git, Kitty, Neovim, tmux, and VS Code user config.
- SSH public configuration and host metadata.
- APT, Snap, and Flatpak package inventories.
- VS Code extension lists.

Excluded:

- Private SSH keys.
- Passwords, tokens, or API secrets.
- Local override files such as `~/.bashrc_local` and `~/.zshrc_local`.

## Restore Behavior

Restore does four things in order:

1. Installs packages from `packages/apt.txt`, `packages/snap.txt`, and `packages/flatpak.txt`.
2. Symlinks the tracked configuration roots into `$HOME`.
3. Restores snapshot-specific files if a snapshot is supplied.
4. Reinstalls VS Code extensions when a VS Code binary is available.

## Security Rules

- Never commit private SSH keys.
- Never commit secrets, tokens, or machine-specific credentials.
- Keep secrets in local override files ignored by Git.
- Review `git status` before pushing.
- Keep SSH config as `ssh/config.example` in Git; use your local `~/.ssh/config` for the real file.

## Package Strategy

- `packages/apt.txt` is the Ubuntu/Debian baseline.
- `packages/snap.txt` is for Snap packages you explicitly want.
- `packages/flatpak.txt` is for desktop apps that are easier to manage through Flatpak.

To add a dependency:

1. Install it locally.
2. Add it to the correct manifest.
3. Run `bash scripts/restore.sh` in a clean environment and verify the result.

## Maintenance Workflow

A practical routine is:

```bash
git status
git diff
bash scripts/backup.sh
bash scripts/restore.sh
```

Use `backup.sh` before major config changes or before moving to a new machine. Use `restore.sh` to validate that the repo still recreates your environment correctly.

## Future Migration

The layout is intended to stay useful for:

- Another Ubuntu machine: direct fit.
- WSL: shell, Git, Neovim, tmux, and VS Code state remain reusable.
- Another Linux distribution: the structure stays the same, while package manifests may need translation.

## File Notes

### `bash/.bashrc` and `bash/.profile`
Shell startup files with PATH setup, aliases, and a local override hook.

### `git/.gitconfig`
Tracked Git defaults. Update the `user` section before committing as yourself.

### `nvim/`
Full Neovim config. The restore flow symlinks the directory into `~/.config/nvim`.

### `kitty/`
Terminal configuration, including theme includes.

### `tmux/.tmux.conf`
tmux keybindings and default behavior.

### `vscode/extensions.txt`
Curated extension list used by restore.

### `cp/`
Competitive programming template and launcher script.

## Useful Commands

```bash
# Create a new CP file
cpnew solution.cpp

# Inspect VS Code extensions
code --list-extensions

# Regenerate a backup snapshot
bash scripts/backup.sh
```

## Notes

This repository treats tracked configuration and machine-specific state separately. If something is unique to one host, keep it in the snapshot layer or in ignored local override files.
