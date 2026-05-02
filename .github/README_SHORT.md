# Competitive Programming Dotfiles

A minimal, production-ready dotfiles repository for C++ competitive programming on Linux.

## 🎯 Features

- ⚡ **One-command installation**: `bash install.sh`
- 🐧 **Multi-distro support**: Ubuntu/Debian & Arch Linux
- 🛡️ **Safe installation**: Automatic backups before any changes
- 🔗 **Symlink-based**: Changes in repo update everywhere
- 📦 **Pre-configured**: Neovim, Git, Bash, Kitty terminal
- 🚀 **CP-ready**: Template and utilities for competitive programming

## 📦 Quick Install

```bash
git clone https://github.com/yourusername/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
bash install.sh
```

Then reload:
```bash
source ~/.bashrc
```

## 🚀 Usage

### Create new CP file
```bash
cpnew solution.cpp
```

### Compile and run in Neovim
Press `<Space>r` to compile and run your C++ code

### Git workflow
```bash
gs          # git status
ga file.cpp # git add
gc -m "msg" # git commit
gp          # git push
```

## 📁 What's Included

- **Neovim** (`~/.config/nvim`): Optimized for C++ with `<Space>r` for compile+run
- **Bash** (`~/.bashrc`, `~/.profile`): Shell configuration with useful aliases
- **Git** (`~/.gitconfig`): Pre-configured with helpful aliases
- **Kitty** (`~/.config/kitty`): Terminal config with clean aesthetics
- **CP Tools** (`cpnew`, template.cpp): For competitive programming

## ⚙️ Key Bindings

### Neovim
- `<Space>r` → Compile and run C++
- `<Space>w` → Save
- `<Space>q` → Quit
- `<C-h/j/k/l>` → Navigate windows
- `<A-j/k>` → Move lines

### Kitty
- `Alt+Enter` → Fullscreen
- `Ctrl+Shift+T` → New tab
- `Ctrl+Shift+C/V` → Copy/Paste

## ✅ Safety

- Existing configs backed up to `~/.backup_dotfiles/`
- No data destruction
- Easy to undo (backups remain)

## 📖 For More Details

See [README.md](README.md) for comprehensive documentation.

## 🔗 Setup Your Repo

1. Fork or create your own dotfiles repo
2. Update `git/.gitconfig` with your name and email
3. Customize configs as needed
4. Push to GitHub

```bash
git remote set-url origin https://github.com/yourusername/dotfiles.git
git push -u origin main
```

---

**Ready to code!** 🎉
