# 🛠️ MyDotfiles - Newborn PC Setup & Deployment Guide

Transform a fresh Ubuntu/Debian installation into your complete development environment with a single deployment script.

This repository contains my personal configuration files (**dotfiles**) for:

- 🖥️ Kitty Terminal
- ⚡ Neovim (Lazy.nvim)
- 🐚 Zsh
- 🪟 Tmux
- ⚙️ Various CLI tools

---

# 📋 Table of Contents

- [Step 1: Pre-requisites & Application Installation](#-step-1-pre-requisites--application-installation)
- [Step 2: Clone and Deploy Your Dotfiles](#-step-2-clone-and-deploy-your-dotfiles)
- [Step 3: Post Installation](#-step-3-post-installation)
- [Troubleshooting](#-troubleshooting)

---

# 📦 Step 1: Pre-requisites & Application Installation

Before deploying the dotfiles, install all required software.

---

## 1. Update Your System

```bash
sudo apt update && sudo apt upgrade -y
```

---

## 2. Install Core Utilities

These packages are required for development, compiling plugins, and managing repositories.

```bash
sudo apt install -y \
git \
curl \
build-essential \
stow \
zsh \
tmux
```

---

## 3. Install the Latest Stable Neovim

> **Important**
>
> Do **NOT** use Ubuntu's default Neovim package.
>
> Modern Lua configurations require a newer version.

Add the official Neovim PPA:

```bash
sudo add-apt-repository ppa:neovim-ppa/stable -y
```

Update repositories:

```bash
sudo apt update
```

Install Neovim:

```bash
sudo apt install -y neovim
```

---

## 4. Install Kitty Terminal

```bash
sudo apt install -y kitty
```

---

# 🚀 Step 2: Clone and Deploy Your Dotfiles

After installing all required software, deploy your configurations.

---

## 1. Clone the Repository

Clone directly into a hidden directory inside your home folder.

```bash
git clone https://github.com/MehediXT/Mydotfiles.git ~/.dotfiles
```

Move into the repository.

```bash
cd ~/.dotfiles
```

---

## 2. Make the Installer Executable

Fresh Git repositories do not preserve executable permissions.

```bash
chmod +x install.sh
```

---

## 3. Run the Installer

```bash
./install.sh
```

The installer will:

- Remove old configuration folders
- Create the required directory structure
- Create symbolic links
- Deploy all configurations

---

# 🎨 Step 3: Post Installation

## Initialize Neovim

Launch Neovim for the first time.

```bash
nvim
```

On the first launch:

- Lazy.nvim installs automatically
- All plugins are downloaded
- Tree-sitter parsers are compiled
- The Aylin theme is installed

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

---

# 🔍 Troubleshooting

## install.sh Finished Instantly

If the installer appears to finish immediately but nothing changes:

- Ensure you're inside the repository.

```bash
cd ~/.dotfiles
```

Run:

```bash
./install.sh
```

Avoid using:

```bash
bash install.sh
```

Some relative paths may not resolve correctly.

---

## Symbolic Links Were Not Created

Ensure your installer creates the parent directory before linking.

Example:

```bash
mkdir -p "$HOME/.config"
```

---

## Neovim Tree-sitter Errors

Tree-sitter requires a local C compiler.

Install:

```bash
sudo apt install build-essential
```

Then reopen Neovim.

---

## Plugins Fail to Install

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

## Verify Installed Versions

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

# 📁 Repository Structure

```text
~/.dotfiles
├── install.sh
├── kitty/
├── nvim/
├── tmux/
├── zsh/
└── README.md
```

---

# ❤️ Credits

Personal dotfiles maintained by **MehediXT**.

Feel free to fork, modify, and adapt them to your own workflow.