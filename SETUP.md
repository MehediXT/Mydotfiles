# 🚀 Complete Setup Guide - Competitive Programming Environment

This guide will help you set up your complete C++ competitive programming environment on any Linux machine using this dotfiles repository.

---

## 📋 Table of Contents

1. [System Requirements](#system-requirements)
2. [Quick Start (One Command)](#quick-start-one-command)
3. [Step-by-Step Installation](#step-by-step-installation)
4. [Post-Installation Setup](#post-installation-setup)
5. [Troubleshooting](#troubleshooting)
6. [What Gets Installed](#what-gets-installed)
7. [Keyboard Shortcuts](#keyboard-shortcuts)
8. [Daily Workflow](#daily-workflow)

---

## 📦 System Requirements

### Supported Operating Systems
- ✅ Ubuntu 20.04+
- ✅ Debian 11+
- ✅ Arch Linux
- ✅ Manjaro
- ✅ Any Debian/Arch-based Linux

### Hardware Requirements
- 2GB RAM minimum
- 500MB disk space
- Internet connection (for package downloads)

---

## ⚡ Quick Start (One Command)

### Clone and Install
```bash
git clone https://github.com/MehediXT/Mydotfiles.git ~/.dotfiles
cd ~/.dotfiles
bash install.sh
source ~/.bashrc
```

That's it! Your environment is ready. Jump to [Post-Installation Setup](#post-installation-setup).

---

## 🔧 Step-by-Step Installation

### Step 1: Clone the Repository

Choose your preferred location. Recommended: `~/.dotfiles`

```bash
git clone https://github.com/MehediXT/Mydotfiles.git ~/.dotfiles
cd ~/.dotfiles
```

**What this does:**
- Downloads all configuration files
- Creates directory at `~/.dotfiles`
- Navigates into the directory

**Output should show:**
```
Cloning into '/home/username/.dotfiles'...
remote: Enumerating objects...
Receiving objects: 100% (XX/XX), XXXMB | XXXKB/s
```

---

### Step 2: Run the Installation Script

```bash
bash install.sh
```

This script will:

#### 2.1 Detect Your OS
- Automatically identifies Ubuntu/Debian or Arch
- Selects appropriate package manager

**Expected output:**
```
[✓] Detected: ubuntu 22.04
```

#### 2.2 Install Dependencies
Installs these packages:
- **git** - Version control
- **neovim** - Text editor
- **build-essential** - C++ compiler (g++, make, etc.)
- **kitty** - Terminal emulator
- **ripgrep** - Fast search utility
- **nodejs** & **npm** - For Neovim plugins
- **curl** & **wget** - Download utilities

**Installation may take 2-5 minutes depending on internet speed**

**Expected output:**
```
[INFO] Installing: git neovim build-essential kitty...
[✓] Ubuntu/Debian packages installed!
```

#### 2.3 Backup Existing Configs
- Creates backup of your existing configurations
- Located at: `~/.backup_dotfiles/backup_YYYYMMDD_HHMMSS/`
- Safe to delete after verifying installation works

**Expected output:**
```
[INFO] Backing up .bashrc...
[✓] Backed up 3 configurations
Location: /home/username/.backup_dotfiles/backup_20260503_023000
```

#### 2.4 Create Symlinks
Creates links from your home directory to the dotfiles:

```
~/.bashrc              → ~/.dotfiles/bash/.bashrc
~/.profile             → ~/.dotfiles/bash/.profile
~/.gitconfig           → ~/.dotfiles/git/.gitconfig
~/.config/nvim         → ~/.dotfiles/nvim
~/.config/kitty        → ~/.dotfiles/kitty
```

**Why symlinks?**
- Changes in the repo are immediately reflected
- Easy to update by just pulling new changes
- One source of truth for all machines

**Expected output:**
```
[✓] ~/.bashrc → /home/username/.dotfiles/bash/.bashrc
[✓] ~/.profile → /home/username/.dotfiles/bash/.profile
[✓] ~/.config/nvim → /home/username/.dotfiles/nvim
[✓] ~/.config/kitty → /home/username/.dotfiles/kitty
```

#### 2.5 Setup CP Tools
- Makes `cpnew.sh` executable
- Adds competitive programming scripts to PATH
- Ready to create new CP files

**Expected output:**
```
[✓] cpnew.sh is now executable
[✓] Added CP tools to PATH
```

#### 2.6 Install Neovim Plugins
- Runs lazy.nvim plugin manager
- Downloads all plugins from `lazy-lock.json`
- Uses exact versions for consistency

**Expected output:**
```
[INFO] This will take a moment (lazy.nvim downloading plugins)...
[INFO] Waiting for lazy.nvim to initialize plugins...
[✓] Neovim plugin setup complete!
```

**Note:** First Neovim launch may still download some plugins.

#### 2.7 Verification
- Checks all tools are installed correctly
- Verifies symlinks are working
- Reports any issues

**Expected output:**
```
[✓] nvim installed
[✓] git installed
[✓] g++ installed
[✓] kitty installed
[✓] ~/.config/nvim is symlinked
```

---

### Step 3: Reload Your Shell

```bash
source ~/.bashrc
```

This loads all new aliases and environment variables.

**What this enables:**
- All bash aliases (ll, gs, ga, gc, etc.)
- CP tools in PATH
- Environment variables
- Custom functions

---

### Step 4: Verify Installation

Test each component:

#### 4.1 Test Neovim
```bash
nvim --version
```
Should show version 0.8+

#### 4.2 Test Aliases
```bash
ll
```
Should show long listing format

#### 4.3 Test Git
```bash
gs
```
Should show git status (or error if not a git repo, which is fine)

#### 4.4 Test CP Tools
```bash
which cpnew
```
Should show path to cpnew.sh

---

## 📝 Post-Installation Setup

### Essential: Update Git User Info

Edit `~/.dotfiles/git/.gitconfig` and update:

```ini
[user]
    name = Your Full Name
    email = your.email@example.com
```

Or use command line:
```bash
git config --global user.name "Your Full Name"
git config --global user.email "your.email@example.com"
```

**Verify:**
```bash
git config --global user.name
git config --global user.email
```

---

### Optional: Customize Bashrc

Add machine-specific settings without modifying the dotfiles:

Create `~/.bashrc_local`:
```bash
# ~/.bashrc_local
# Machine-specific settings (not tracked by git)

# Add custom aliases
alias myalias="command"

# Export custom variables
export MY_VAR="value"

# Add functions
my_function() {
    echo "Hello from $HOSTNAME"
}
```

This file is automatically sourced by `.bashrc` and won't be tracked by git.

---

### Optional: Customize Neovim

Edit `~/.config/nvim/lua/options.lua` to adjust:
- Tab width
- Line number display
- Color scheme
- Key bindings

**Common customizations:**
```lua
-- Tab width (change 4 to 2 or 8)
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4

-- Always show line numbers
vim.opt.number = true

-- Disable relative line numbers
vim.opt.relativenumber = false
```

---

### Optional: Customize Kitty

Edit `~/.config/kitty/kitty.conf` to adjust:
- Font size
- Color theme
- Window padding
- Key bindings

**Common customizations:**
```conf
# Change font size
font_size 13.0

# Change padding
window_padding_width 10

# Change line height
line_height 1.3
```

Available themes in `~/.config/kitty/`:
- `current-theme.conf` (current)
- `Dracula.conf` (Dracula theme)

---

## 🎯 Daily Workflow

### Creating a New Competitive Programming Solution

```bash
# Step 1: Create new file from template
cpnew problem.cpp

# Step 2: Opens in Neovim automatically
# Write your solution...

# Step 3: Compile and run (inside Neovim)
# Press: <Space>r

# Step 4: Submit to platform
git add problem.cpp
git commit -m "Solve Problem: XYZ"
git push
```

### Using Git

```bash
# Check status
gs

# View recent commits
gl

# Add files
ga solution.cpp

# Commit
gc -m "Add solution"

# Push to GitHub
gp

# View commit tree
git visual
```

### Neovim Keybindings

| Shortcut | Action |
|----------|--------|
| `<Space>r` | **Compile & Run C++** |
| `<Space>w` | Save file |
| `<Space>q` | Quit |
| `<Space>e` | Open file explorer |
| `<C-h/j/k/l>` | Navigate windows |
| `<A-j/k>` | Move lines up/down |
| `/pattern` | Search in file |
| `<Esc>` | Clear highlights |

### Kitty Terminal

| Shortcut | Action |
|----------|--------|
| `Alt+Enter` | Fullscreen |
| `Ctrl+Shift+T` | New tab |
| `Ctrl+Tab` | Next tab |
| `Ctrl+Shift+Tab` | Previous tab |
| `Ctrl+Shift+C` | Copy |
| `Ctrl+Shift+V` | Paste |

---

## 🐛 Troubleshooting

### Issue: `bash: cpnew: command not found`

**Solution:**
```bash
# Reload bashrc
source ~/.bashrc

# Or manually add to PATH
export PATH="$PATH:~/.dotfiles/cp"
```

---

### Issue: Neovim shows errors on startup

**Solution:**
```bash
# Neovim might still be downloading plugins
# This is normal on first launch

# Wait 30 seconds and try again
nvim

# Or manually sync plugins
nvim --headless "+Lazy! sync" +qa
```

---

### Issue: Git config not recognized

**Solution:**
```bash
# Check if .gitconfig is symlinked
ls -la ~/.gitconfig

# If not, recreate symlink
ln -sf ~/.dotfiles/git/.gitconfig ~/.gitconfig

# Verify
git config --global user.name
```

---

### Issue: Kitty terminal not launching

**Solution:**
```bash
# Check if installed
kitty --version

# If not, reinstall
sudo apt install kitty        # Ubuntu/Debian
sudo pacman -S kitty          # Arch

# Or use default terminal with dotfiles
# The bash configs work in any terminal
```

---

### Issue: g++ not found when compiling

**Solution:**
```bash
# Check if installed
g++ --version

# If not, reinstall build tools
sudo apt install build-essential        # Ubuntu/Debian
sudo pacman -S base-devel               # Arch

# Verify
g++ --version
```

---

### Issue: Something went wrong during install

**Solution:**
```bash
# Restore from backup
cp -r ~/.backup_dotfiles/backup_YYYYMMDD_HHMMSS/* ~/

# Run install again
cd ~/.dotfiles
bash install.sh
```

---

### Issue: Can't push to GitHub

**Solution:**
```bash
# Check remote is set correctly
git remote -v

# If needed, update remote
git remote set-url origin https://github.com/MehediXT/Mydotfiles.git

# Try pushing again
git push -u origin main
```

---

## 📦 What Gets Installed

### System Packages
| Package | Purpose |
|---------|---------|
| **git** | Version control |
| **neovim** | Text editor (0.8+) |
| **g++** | C++ compiler |
| **make** | Build automation |
| **build-essential** | Compilation tools (Ubuntu/Debian) |
| **base-devel** | Development tools (Arch) |
| **kitty** | Terminal emulator |
| **ripgrep** | Fast file search |
| **nodejs** | JavaScript runtime (for plugins) |
| **npm** | Node package manager |
| **curl** | Data transfer utility |
| **wget** | Download utility |

### Neovim Plugins (via lazy.nvim)
| Plugin | Purpose |
|--------|---------|
| **NvChad** | Base configuration framework |
| **competitest** | Competitive programming testing |
| **treesitter** | Syntax highlighting |
| **lsp** | Language server protocol |
| **blink** | Autocompletion engine |
| **conform** | Code formatter |
| **nvim-tree** | File explorer |
| **telescope** | Fuzzy finder |
| **markdown** | Markdown preview |
| **peek** | Image preview |
| **nabla** | Math rendering |
| **rustaceanvim** | Rust support |
| **csv** | CSV file handling |
| And more! | See lazy-lock.json |

### Configuration Files
| File | Location | Purpose |
|------|----------|---------|
| **init.lua** | ~/.config/nvim/ | Neovim main config |
| **kitty.conf** | ~/.config/kitty/ | Terminal config |
| **.bashrc** | ~/ | Bash configuration |
| **.profile** | ~/ | Shell profile |
| **.gitconfig** | ~/ | Git configuration |
| **lazy-lock.json** | ~/.config/nvim/ | Plugin versions locked |

---

## 🎓 Useful Commands for Competitive Programming

### Compile with Optimizations
```bash
g++ -o solution solution.cpp -std=c++17 -O2
```

### Compile with Debugging
```bash
g++ -o solution solution.cpp -std=c++17 -g -Wall -Wextra
```

### Run with Input File
```bash
./solution < input.txt
```

### Run with Input and Redirect Output
```bash
./solution < input.txt > output.txt
```

### Time Your Program
```bash
time ./solution < input.txt
```

### Generate Test Cases
```bash
# Use competitest plugin in Neovim
# Or create input files manually
echo "5
10 20
30 40
50 60
70 80
90 100" > input.txt
```

---

## 🔗 Useful Resources

### Competitive Programming
- [Codeforces](https://codeforces.com/)
- [AtCoder](https://atcoder.jp/)
- [LeetCode](https://leetcode.com/)
- [HackerEarth](https://www.hackerearth.com/)

### Learning Resources
- [Neovim Docs](https://neovim.io/doc/user/)
- [Kitty Documentation](https://sw.kovidgoyal.net/kitty/conf/)
- [Git Documentation](https://git-scm.com/doc)
- [Bash Guide](https://mywiki.wooledge.org/BashGuide)
- [C++ Reference](https://en.cppreference.com/)

### Tips
- Practice on Codeforces regularly
- Use competitest plugin to test locally
- Keep solutions organized in git
- Review previous solutions

---

## 🔄 Keeping Your Dotfiles Updated

### Pull Latest Changes
```bash
cd ~/.dotfiles
git pull origin main
```

Changes take effect immediately since everything is symlinked!

### Update on All Machines
Just run `git pull` on each machine. No reinstall needed.

---

## 🛠️ Maintaining Your Setup

### Add New Aliases
Edit `~/.dotfiles/bash/.bashrc`:
```bash
alias myalias="command"
```

Then reload:
```bash
source ~/.bashrc
```

### Add Neovim Plugins
Edit `~/.dotfiles/nvim/lua/plugin/init.lua` to add plugins, then reload Neovim.

### Backup Current State
```bash
cd ~/.dotfiles
git add .
git commit -m "Backup: current state"
git push
```

---

## 📞 Support

If you encounter issues:

1. **Check Troubleshooting** section above
2. **Review terminal output** for error messages
3. **Check backup** to restore if needed
4. **Reinstall** by running `bash install.sh` again

---

## ✅ Checklist for New Setup

- [ ] Clone repository
- [ ] Run `bash install.sh`
- [ ] Reload shell: `source ~/.bashrc`
- [ ] Update git user info
- [ ] Test Neovim: `nvim ~/.bashrc`
- [ ] Create test CP file: `cpnew test.cpp`
- [ ] Compile & run: `<Space>r` in Neovim
- [ ] Verify git: `gs` (git status)
- [ ] Make a test commit
- [ ] Push to GitHub

---

## 🎉 You're Ready!

Your complete C++ competitive programming environment is set up and ready to use.

**Quick Start:**
```bash
cpnew solution.cpp
# Write code in Neovim
# Press <Space>r to compile & run
# Push to GitHub when done
```

**Happy Coding! 🚀**

---

## 📝 Changelog

### Version 1.0 (May 3, 2026)
- Initial setup with NvChad configuration
- Full Neovim plugin suite
- Kitty terminal with Dracula theme
- Bash configuration with aliases
- Competitive programming templates
- One-command installation script

---

**Last Updated:** May 3, 2026
**Author:** Your Name
**Repository:** https://github.com/MehediXT/Mydotfiles
