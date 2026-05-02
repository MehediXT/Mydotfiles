# Competitive Programming Dotfiles

A clean, minimal dotfiles repository for C++ competitive programming on Linux. Includes Neovim, Kitty terminal, Git, and Bash configurations.

## 🚀 Quick Start

### Installation (One Command)

```bash
git clone https://github.com/yourusername/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
bash install.sh
```

The script will:
- ✅ Detect your Linux distribution (Ubuntu/Debian or Arch)
- ✅ Install dependencies: `git`, `neovim`, `g++`, `kitty`
- ✅ Backup your existing configs (if any) to `~/.backup_dotfiles`
- ✅ Create symlinks for all configurations

### After Installation

Reload your shell:
```bash
source ~/.bashrc
```

## 📁 Repository Structure

```
dotfiles/
├── install.sh              # Main installation script
├── README.md               # This file
├── bash/
│   ├── .bashrc             # Bash configuration with aliases
│   └── .profile            # Shell profile setup
├── git/
│   └── .gitconfig          # Git configuration
├── nvim/
│   └── init.lua            # Neovim config (C++ optimized)
├── kitty/
│   └── kitty.conf          # Kitty terminal config
└── cp/
    ├── template.cpp        # C++ competitive programming template
    └── cpnew.sh            # Script to create new CP files
```

## ⚙️ Configuration Details

### Bash Aliases

After installation, you'll have these handy aliases:

```bash
ll              # ls -lah (detailed listing)
la              # ls -A (all files)
gs              # git status
ga              # git add
gc              # git commit
gp              # git push
gl              # git log (last 10)
compile         # g++ -o solution solution.cpp -std=c++17 -O2
run             # ./solution
cpcompile       # Full compilation with warnings and debug info
```

### Neovim Key Bindings

| Shortcut | Action |
|----------|--------|
| `<leader>r` | Compile and run C++ file |
| `<leader>w` | Quick save |
| `<leader>q` | Quit |
| `<leader>ev` | Edit config |
| `<leader>sv` | Reload config |
| `<C-h/j/k/l>` | Navigate windows |
| `<A-j/k>` | Move lines up/down |

**Leader key:** Space (`<Space>`)

### Kitty Shortcuts

| Shortcut | Action |
|----------|--------|
| `Alt+Enter` | Toggle fullscreen |
| `Ctrl+Shift+C` | Copy |
| `Ctrl+Shift+V` | Paste |
| `Ctrl+Shift+T` | New tab |
| `Ctrl+Tab` | Next tab |
| `Ctrl+Shift+Tab` | Previous tab |

## 🎯 Competitive Programming Workflow

### Creating a New CP File

```bash
cpnew solution.cpp
```

This will:
1. Copy the template from `cp/template.cpp`
2. Create `solution.cpp` with fast I/O setup
3. Open it in Neovim

### Compiling and Running

Inside Neovim, press `<Space>r` to compile and run:
```bash
:! g++ -o /tmp/sol % -std=c++17 -O2 && /tmp/sol
```

Or manually in terminal:
```bash
g++ -o solution solution.cpp -std=c++17 -O2
./solution
```

### Using the Template

The template includes:
- Fast I/O configuration
- Multiple test case structure
- Common includes (`bits/stdc++.h`)
- Basic main function with input/output

Modify as needed for your problem!

## 📋 Template Example

```cpp
#include <bits/stdc++.h>
using namespace std;

int main() {
    ios_base::sync_with_stdio(false);
    cin.tie(nullptr);
    
    int t;
    cin >> t;
    
    while (t--) {
        // Read input
        int n;
        cin >> n;
        
        // Solve problem
        
        
        // Output answer
        cout << "Answer here\n";
    }
    
    return 0;
}
```

## 🔧 Neovim Features

### Tab Settings
- Tab width: 4 spaces
- Auto-indent: enabled
- Smart indent: enabled

### Display
- Line numbers: enabled
- Highlight current line: enabled
- System clipboard support: enabled
- True color support: enabled

### Useful Commands
```vim
:set number         " Show line numbers
:set nonumber       " Hide line numbers
:set relativenumber " Use relative line numbers
:nohl              " Clear search highlights
```

## 📝 Git Configuration

- Default editor: Neovim
- Default branch: main
- Helpful aliases configured:
  - `git st` → `git status`
  - `git co` → `git checkout`
  - `git br` → `git branch`
  - `git visual` → Visual commit log

### Customize Git User

Edit `git/.gitconfig` and update:
```ini
[user]
    name = Your Name
    email = your.email@example.com
```

Or use command line:
```bash
git config --global user.name "Your Name"
git config --global user.email "your.email@example.com"
```

## 🔄 Updating Dotfiles

To sync changes across machines:

```bash
cd ~/.dotfiles
git pull
source ~/.bashrc
```

Your symlinks remain intact, so changes take effect immediately!

## 💾 Backups

Before installation, existing configs are backed up to:
```
~/.backup_dotfiles/backup_YYYYMMDD_HHMMSS/
```

Safe to delete after verifying everything works!

## ⚠️ Important Notes

### What's NOT Included
- ❌ SSH keys (`~/.ssh`)
- ❌ Shell history (`~/.bash_history`, `~/.zsh_history`)
- ❌ Cache files (`~/.cache`)
- ❌ Temporary files or binaries
- ❌ Package manager caches

### What's Included
- ✅ Shell configs (`.bashrc`, `.profile`)
- ✅ Git configuration
- ✅ Neovim config (minimal, fast)
- ✅ Kitty terminal config
- ✅ CP templates and utilities

## 🛠️ Customization

### Add Machine-Specific Configs

Create `~/.bashrc_local` for machine-specific settings:
```bash
# ~/.bashrc_local
export CUSTOM_VAR="value"
alias myalias="command"
```

This file is sourced automatically by `.bashrc`.

### Modify Neovim Plugins

Edit `nvim/init.lua` to add plugins (e.g., packer.nvim, lazy.nvim).

### Add New Aliases

Edit `bash/.bashrc` in your dotfiles, then run:
```bash
source ~/.bashrc
```

## 📚 Resources

- [Neovim Docs](https://neovim.io/doc/user/)
- [Kitty Docs](https://sw.kovidgoyal.net/kitty/conf/)
- [Bash Guide](https://mywiki.wooledge.org/BashGuide)
- [Git Docs](https://git-scm.com/doc)

## 🐛 Troubleshooting

### Symlinks not working
```bash
# Check symlinks
ls -la ~/.bashrc ~/.config/nvim

# Reinstall
cd ~/.dotfiles
bash install.sh
```

### Neovim not opening
```bash
# Ensure Neovim is installed
nvim --version

# If not installed
sudo apt install neovim  # Ubuntu/Debian
sudo pacman -S neovim    # Arch
```

### cpnew command not found
```bash
# Add to PATH manually
source ~/.bashrc

# Or add to bashrc
echo 'export PATH="$PATH:~/.dotfiles/cp"' >> ~/.bashrc
source ~/.bashrc
```

## 📄 License

MIT License - Feel free to modify and use!

## 🤝 Contributing

Feel free to fork, modify, and adapt to your needs!

---

**Happy coding! 🚀**

For competitive programming tips, visit:
- [Codeforces](https://codeforces.com/)
- [AtCoder](https://atcoder.jp/)
- [LeetCode](https://leetcode.com/)
