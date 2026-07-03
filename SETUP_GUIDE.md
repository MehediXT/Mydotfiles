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
- [Step 3: Post Installation](#step-3-post-installation)
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
git clone <your-dotfiles-repo-url> ~/.dotfiles
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

`install.sh` is a thin wrapper around the real bootstrap flow. It will:

- install the packages from [packages/apt.txt](packages/apt.txt)
- add the Neovim stable PPA when needed
- link the tracked config directories into your home folder
- restore VS Code extensions from [vscode/extensions.txt](vscode/extensions.txt)

---

# Step 3: Post Installation

## Initialize Neovim

Launch Neovim for the first time.

```bash
nvim
```

On the first launch:

- Lazy.nvim installs automatically
- All plugins are downloaded
- Tree-sitter parsers are compiled
- The configured theme and LSP tools are loaded

Wait until installation reaches **100%**.

Exit Neovim:

```
:q
```

Open it again:

```bash
nvim
```

Your full development environment should now be ready.

---

## Make Zsh Your Default Shell (Optional)

To automatically start your customized Zsh configuration:

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