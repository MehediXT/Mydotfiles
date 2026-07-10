# MyDotfiles Setup Guide

This repository turns a fresh Ubuntu/Debian machine into a working development environment using the tracked package manifests and bootstrap scripts.

It includes configuration for:

- Kitty
- Neovim with Lazy.nvim
- Zsh
- Tmux
- Git, SSH, VS Code, and CLI tools

---

# 📋 Table of Contents

- [Step 1: Pre-requisites](#step-1-pre-requisites)
- [Step 2: Clone and Deploy Your Dotfiles](#step-2-clone-and-deploy-your-dotfiles)
- [Step 3: Copying this setup to another new device](#step-3-copying-this-setup-to-another-new-device)
- [Step 4: Post Installation](#step-4-post-installation)
- [Troubleshooting](#troubleshooting)

---

# Step 1: Pre-requisites

Before deploying the dotfiles, install the base tools required by the bootstrap scripts.

---

## 1. Update Your System

```bash
sudo apt update && sudo apt upgrade -y
```

---

## 2. Install Core Utilities

These packages cover the minimum required tools for cloning the repo and running the bootstrap flow.

```bash
sudo apt install -y \
git \
curl \
build-essential \
software-properties-common
```

---

## 3. Install the repo dependencies

The repository keeps the package list in [packages/apt.txt](packages/apt.txt). The bootstrap flow installs that list automatically, including Neovim, tmux, zsh, Kitty, and the common CLI tools used by the configs.

If you want to verify the package list before bootstrapping, inspect:

```bash
cat packages/apt.txt
```

Kitty is included there as well, so you do not need a separate manual install step.

---

# Step 2: Clone and Deploy Your Dotfiles

After installing all required software, deploy your configurations.

---

## 1. Clone the Repository

Clone directly into a hidden directory inside your home folder.

```bash
git clone <https://github.com/MehediXT/Mydotfiles.git> ~/.dotfiles
```

Move into the repository.

```bash
cd ~/.dotfiles
```

---

## 2. Run the Installer

```bash
./install.sh
```

`install.sh` makes sure the base tools (`git`, `curl`, `ca-certificates`) exist, then forwards to `bootstrap.sh`. The bootstrap flow will:

- install the packages from [packages/apt.txt](packages/apt.txt)
- add the Neovim stable PPA when needed
- link the tracked config directories into your home folder
- restore VS Code extensions from [vscode/extensions.txt](vscode/extensions.txt)
- **build the Neovim environment automatically** (install plugins via Lazy and compile Tree-sitter grammars) so you do not need a manual first launch

### Installer options

`install.sh` passes all arguments through to `bootstrap.sh`. Useful flags:

```bash
bash install.sh --no-build     # link configs but skip the Neovim plugin/treesitter build
bash install.sh --set-zsh      # also make zsh your default login shell
bash install.sh --target ~/dotfiles   # clone/use the repo somewhere other than ~/.dotfiles
DOTFILES_REPO_URL=https://github.com/you/dotfiles.git bash install.sh   # use your own fork
```

Run `bash bootstrap.sh --help` for the full list.

---

## 3. Copying this setup to another new device

There are two supported ways to move the environment to a fresh machine.

### Option A — Clone from Git (recommended)

This is the cleanest path and is what the installer assumes by default. A clone never carries nested `.git` directories, so the target stays a single clean repository.

```bash
git clone https://github.com/MehediXT/Mydotfiles.git ~/.dotfiles
cd ~/.dotfiles
bash install.sh
```

### Option B — Copy with `cp` / `rsync` / `tar`

Use this when you cannot clone (e.g. an air-gapped or offline machine). One important caveat: the `nvim/` directory is tracked by this repo **and** kept as its own git repository, so a raw copy would bring along `nvim/.git` and create a confused nested repo on the target. Re-run the installer with `--clean-nested-git` (only on the copied repo, never on the original) to strip nested `.git` directories:

```bash
rsync -a --exclude='.git' ~/dotfiles/ ~/.dotfiles/   # exclude the top-level .git too...
cd ~/.dotfiles
bash install.sh --clean-nested-git
```

If a nested `.git` is detected and you did not pass `--clean-nested-git`, the installer prints a warning and continues without deleting anything.

---

# Step 4: Post Installation

## Verify Neovim

The installer already runs the Neovim build for you (`+LazySync` + `+TSUpdateSync`), so plugins and Tree-sitter grammars are installed before it finishes. A first launch is only needed to confirm everything looks right:

```bash
nvim
```

On first interactive launch the theme and LSP tools load. If anything failed during the automated build, open Neovim and run:

```vim
:Lazy sync
:TSUpdate
```

or simply reopen Neovim — your full development environment should now be ready.

---

## Make Zsh Your Default Shell (Optional)

To automatically start your customized Zsh configuration, either run the installer with `--set-zsh`, or do it manually:

```bash
chsh -s $(which zsh)
```

> **Note**
>
> Log out and log back in for the change to take effect.

# Troubleshooting

## The installer exits quickly

If the installer appears to finish immediately, make sure you are running it from inside the cloned repository:

```bash
cd ~/.dotfiles
./install.sh
```

`install.sh` now forwards to `bootstrap.sh`, so it should work as long as the repository is present.

---

## Symbolic links were not created

The bootstrap flow creates the required parent directories before linking. If a file still was not linked, check whether the source exists in the repo and whether a local file already blocked the link.

## Neovim Tree-sitter errors

Tree-sitter requires a local C compiler and the repo already installs `build-essential` through the package manifest.

If parsers still fail, reopen Neovim and run `:TSUpdate`.

---

## Plugins fail to install

Check that you have an active internet connection.

Inside Neovim:

```vim
:Lazy sync
```

or

```vim
:Lazy update
```

---

## "Nested .git directory detected" warning

If the installer prints a warning about a nested `.git` (e.g. `nvim/.git`), it means the repo was copied with `cp`/`rsync`/`tar` and carried a nested git repository. The installer does **not** delete anything automatically. To fix it, re-run from the copied checkout with:

```bash
bash install.sh --clean-nested-git
```

Only run this on the copied target, never on the original machine. A `git clone` never triggers this because clones exclude nested `.git` directories.

---

## Verify installed versions

Git

```bash
git --version
```

Neovim

```bash
nvim --version
```

Kitty

```bash
kitty --version
```

Zsh

```bash
zsh --version
```

Tmux

```bash
tmux -V
```

---

# Repository Structure

```text
~/.dotfiles
├── install.sh
├── bootstrap.sh
├── scripts/
├── kitty/
├── nvim/
├── packages/
├── tmux/
├── zsh/
├── vscode/
└── README.md
```

---

# Credits

Personal dotfiles maintained for this workspace.

Feel free to fork, modify, and adapt them to your own workflow.