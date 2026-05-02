# 🎉 Your Competitive Programming Dotfiles - Complete Setup Guide

**Location:** `/home/osama-bin/dotfiles`

---

## 📦 CREATED REPOSITORY STRUCTURE

```
dotfiles/
├── install.sh                    # ✅ Main installation script (executable)
├── README.md                     # ✅ Comprehensive documentation
├── .gitignore                    # ✅ Git ignore rules
├── .github/
│   └── README_SHORT.md           # ✅ Quick reference
├── bash/
│   ├── .bashrc                   # ✅ Bash configuration with aliases
│   └── .profile                  # ✅ Shell profile
├── git/
│   └── .gitconfig                # ✅ Git configuration
├── nvim/
│   └── init.lua                  # ✅ Neovim config (C++ optimized)
├── kitty/
│   └── kitty.conf                # ✅ Kitty terminal config
└── cp/
    ├── template.cpp              # ✅ C++ competitive programming template
    └── cpnew.sh                  # ✅ Script to create new CP files (executable)
```

---

## 🚀 QUICK START

### Option 1: Install Locally (Test First)
```bash
cd ~/dotfiles
bash install.sh
source ~/.bashrc
```

### Option 2: Push to GitHub & Install from Anywhere
```bash
cd ~/dotfiles
git init
git add .
git commit -m "Initial dotfiles setup"
git branch -M main
git remote add origin https://github.com/YOUR_USERNAME/dotfiles.git
git push -u origin main

# Then on any machine:
bash install.sh
```

---

## ✨ WHAT'S INCLUDED

### 1. **install.sh** (Smart Installer)
- ✅ Detects OS (Ubuntu/Debian or Arch Linux)
- ✅ Installs: git, neovim, g++, kitty
- ✅ Backs up existing configs to `~/.backup_dotfiles`
- ✅ Creates symlinks (NOT copies) for all configs
- ✅ Sets up CP scripts
- ✅ Color-coded output for clarity
- ✅ Beginner-friendly with safe operations

### 2. **Bash Configuration** (.bashrc, .profile)
Includes these useful aliases:
```bash
ll              # Long listing with all files
la              # List all (including hidden)
gs              # git status
ga              # git add
gc              # git commit
gp              # git push
gl              # git log (last 10 commits)
compile         # Compile C++ with optimizations
run             # Run compiled program
cpcompile       # Full compile with warnings & debug
```

Plus:
- Colored prompt with git branch display
- Tab completion
- History management
- Environment variables

### 3. **Git Configuration** (.gitconfig)
- Default editor: Neovim
- Helpful git aliases (st, co, br, ci, etc.)
- Color output
- Default branch: main
- Smart case-sensitive search

**Must customize:**
```bash
# Edit ~/.gitconfig and update:
[user]
    name = Your Name
    email = your.email@example.com

# Or use command line:
git config --global user.name "Your Name"
git config --global user.email "your.email@example.com"
```

### 4. **Neovim Configuration** (init.lua)
**Features:**
- Line numbers with cursor highlight
- Tab = 4 spaces
- Fast I/O and performance tuning
- System clipboard support
- Tree-sitter ready
- Plugin-ready architecture

**Key Bindings:**
| Key | Action |
|-----|--------|
| `<Space>r` | **Compile & Run C++** 🚀 |
| `<Space>w` | Save file |
| `<Space>q` | Quit |
| `<Space>ev` | Edit Neovim config |
| `<Space>sv` | Reload config |
| `<C-h/j/k/l>` | Navigate windows |
| `<A-j/k>` | Move lines up/down |
| `<Esc>` | Clear search highlights |

**Leader Key:** Space (` `)

### 5. **Kitty Terminal Config**
- Clean, minimal config
- Modern fonts and colors
- Tabbed interface support
- URL detection
- Keyboard shortcuts configured
- Color support for Neovim

**Shortcuts:**
```
Alt+Enter       → Fullscreen
Ctrl+Shift+T    → New tab
Ctrl+Shift+C    → Copy
Ctrl+Shift+V    → Paste
Ctrl+Tab        → Next tab
Ctrl+Shift+Tab  → Previous tab
```

### 6. **CP Tools** (template.cpp + cpnew.sh)

**template.cpp:**
```cpp
#include <bits/stdc++.h>
using namespace std;

int main() {
    ios_base::sync_with_stdio(false);
    cin.tie(nullptr);
    
    int t;
    cin >> t;
    
    while (t--) {
        // Your solution here
    }
    
    return 0;
}
```

**cpnew.sh:**
Usage:
```bash
cpnew solution.cpp    # Creates file and opens in Neovim
```

What it does:
1. Copies template to new file
2. Opens in Neovim (ready to code)
3. Automatic PATH setup

---

## 🎯 TYPICAL WORKFLOW

### Create a new competitive programming solution:
```bash
cpnew solution.cpp
```

### Inside Neovim:
```
1. Type your code
2. Press <Space>r to compile and run
3. Exit with <Space>q
```

### Git workflow:
```bash
gs                  # Check status
ga solution.cpp     # Stage file
gc -m "Solve XYZ"   # Commit
gp                  # Push to GitHub
```

---

## 📋 FILE CONTENTS SUMMARY

### [install.sh](install.sh) (5.1 KB)
- Main installation script
- OS detection (Ubuntu/Debian/Arch)
- Package installation
- Backup management
- Symlink creation
- CP scripts setup

### [bash/.bashrc](bash/.bashrc) (1.8 KB)
- Bash configuration
- Aliases (ll, ga, gs, etc.)
- Prompt with git branch
- History management
- Syntax highlighting support

### [bash/.profile](bash/.profile) (752 B)
- Shell profile
- PATH configuration
- Editor preferences

### [git/.gitconfig](git/.gitconfig) (601 B)
- Git user config (edit this!)
- Git aliases
- Color settings
- Default branch

### [nvim/init.lua](nvim/init.lua) (5.5 KB)
- Neovim configuration
- Line numbers & visual settings
- Keybindings (including compile+run)
- Indentation setup (4 spaces)
- Clipboard support
- Performance tuning

### [kitty/kitty.conf](kitty/kitty.conf) (2.8 KB)
- Terminal configuration
- Font settings
- Color scheme
- Keybindings
- Performance settings

### [cp/template.cpp](cp/template.cpp) (502 B)
- C++ competitive programming template
- Fast I/O setup
- Multiple test case structure

### [cp/cpnew.sh](cp/cpnew.sh) (773 B)
- Script to create new files from template
- Opens in Neovim automatically

### [README.md](README.md) (6.7 KB)
- Comprehensive documentation
- Usage instructions
- Troubleshooting guide
- Customization tips

---

## ⚙️ INSTALLATION CHECKLIST

- [ ] **Before installing:** Review all config files if desired
- [ ] **Run:** `bash ~/dotfiles/install.sh`
- [ ] **Wait:** For installation to complete
- [ ] **Reload:** `source ~/.bashrc`
- [ ] **Test Bash:** `ll` or `gs` commands
- [ ] **Test Neovim:** `nvim ~/.bashrc`
- [ ] **Test CP:** `cpnew test.cpp`
- [ ] **Compile & Run:** Press `<Space>r` in Neovim
- [ ] **Push to GitHub:** (optional, if you want to back up)

---

## 🔧 POST-INSTALLATION CUSTOMIZATION

### Update Git User
```bash
git config --global user.name "Your Name"
git config --global user.email "your.email@example.com"
```

### Add Machine-Specific Configs
Create `~/.bashrc_local` for machine-specific settings:
```bash
# ~/.bashrc_local
export CUSTOM_VAR="value"
alias myalias="command"
```

### Add More Neovim Plugins
Edit `~/.config/nvim/init.lua` and add plugins (packer, lazy.nvim, etc.)

### Customize Aliases
Edit `~/.dotfiles/bash/.bashrc` and run `source ~/.bashrc`

---

## 📝 EXAMPLE COMPETITIVE PROGRAMMING SESSION

```bash
# Step 1: Create new file
$ cpnew codeforces_123.cpp

# Step 2: Neovim opens
# ... write your solution ...

# Step 3: Test compilation (inside Neovim)
# Press <Space>r
# Output: [SUCCESS] Program runs!

# Step 4: Submit
$ git add codeforces_123.cpp
$ git commit -m "Codeforces 123: Solution"
$ git push
```

---

## 🛡️ SAFETY & BACKUPS

✅ **Automatic Backups**
- Existing configs backed up before installation
- Location: `~/.backup_dotfiles/backup_YYYYMMDD_HHMMSS/`
- Easy to restore if needed

✅ **Non-Destructive**
- Uses symlinks (not copies)
- Changes in repo update everywhere
- Easy to undo

✅ **Git-Friendly**
- `.gitignore` configured
- Won't track private keys, history, cache

---

## 🐛 TROUBLESHOOTING

### Problem: `bash: cpnew: command not found`
**Solution:**
```bash
source ~/.bashrc
# If still not working, manually add to PATH:
echo 'export PATH="$PATH:~/.dotfiles/cp"' >> ~/.bashrc
source ~/.bashrc
```

### Problem: Neovim not opening
**Solution:**
```bash
# Check if installed
nvim --version

# If not installed
sudo apt install neovim      # Ubuntu/Debian
sudo pacman -S neovim        # Arch
```

### Problem: Symlinks not working
**Solution:**
```bash
# Check symlinks
ls -la ~/.bashrc ~/.config/nvim

# Reinstall
cd ~/.dotfiles
bash install.sh
```

### Problem: Git won't commit
**Solution:**
```bash
# Update git config
git config --global user.name "Your Name"
git config --global user.email "your.email@example.com"
```

---

## 🚀 NEXT STEPS

1. **Initialize Git Repository** (optional)
   ```bash
   cd ~/dotfiles
   git init
   git add .
   git commit -m "Initial dotfiles commit"
   ```

2. **Push to GitHub** (optional)
   ```bash
   git remote add origin https://github.com/YOUR_USERNAME/dotfiles.git
   git branch -M main
   git push -u origin main
   ```

3. **Start Coding!**
   ```bash
   cpnew solution.cpp
   # Code... Press <Space>r to compile and run
   ```

4. **Share & Backup**
   - Your dotfiles are now on GitHub
   - Install on any machine: `bash install.sh`

---

## 📚 USEFUL RESOURCES

- [Neovim Docs](https://neovim.io/doc/user/)
- [Kitty Docs](https://sw.kovidgoyal.net/kitty/conf/)
- [Bash Guide](https://mywiki.wooledge.org/BashGuide)
- [Git Docs](https://git-scm.com/doc)
- [Competitive Programming Resources](https://codeforces.com/)

---

## ✅ PRODUCTION READY

This dotfiles repository is:
- ✅ Minimal and clean
- ✅ Beginner-friendly
- ✅ Well-documented
- ✅ Safe to install
- ✅ Easy to customize
- ✅ Ready for competitive programming
- ✅ Git-backed (optional)

---

**Happy coding! 🚀**

For questions or issues, refer to the detailed README.md file in your dotfiles folder.
