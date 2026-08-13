# Dotfiles

Portable Bash, Zsh, Git, Kitty, tmux, Neovim, competitive-programming, and
editor configuration with a one-command installer for Ubuntu and Debian Linux.

## Supported systems

The automatic package installation supports Ubuntu, Debian, and distributions
that use `apt-get`. The config-linking part works on other Linux distributions
with `./install.sh --no-packages` after the required programs are installed.

## Quick installation

### From a downloaded ZIP or copied folder

Extract the complete folder and move it to a permanent location. The installed
configs are symbolic links, so deleting or moving the folder afterward will
break those links.

```bash
mv ~/Downloads/Mydotfiles-main ~/.dotfiles
cd ~/.dotfiles
chmod +x install.sh
./install.sh
```

Adjust the first command if the extracted folder has a different name or is in
a different location.

### From Git

```bash
git clone https://github.com/MehediXT/Mydotfiles.git ~/.dotfiles
cd ~/.dotfiles
./install.sh
```

Run the installer as your normal user, not with `sudo`. It requests `sudo` only
when installing system packages.

## What the installer does

The installer:

- installs the packages in `packages/`;
- installs a modern Neovim from Snap because this NvChad config requires
  Neovim 0.11 or newer;
- installs and verifies Deno and JetBrainsMono Nerd Font downloads;
- links every tracked shell/editor config to the correct home-directory path;
- restores VS Code settings, keybindings, and extensions when the `code`
  command is available;
- configures Caps Lock as Escape on GNOME desktops; and
- restores the pinned Neovim plugins and installs the configured Python/Django
  language tools on the first run.

The Neovim synchronization uses explicit XDG paths under the target home
directory. This prevents Snap applications such as VS Code from redirecting
Neovim into a second plugin installation under `~/snap/`.

It does not install VS Code, Ollama, SSH private keys, or private credentials.

## Installer options

Run `./install.sh --help` to see every option.

| Option | Purpose |
| --- | --- |
| `--dry-run` | Preview commands without changing the machine |
| `--no-packages` | Skip APT, Snap, and Flatpak installation |
| `--no-extras` | Skip Deno and Nerd Font installation |
| `--no-neovim-sync` | Skip Neovim plugin and Mason tool synchronization |
| `--no-vscode` | Skip VS Code extension restoration |
| `--no-keyboard` | Skip configuring Caps Lock as Escape |
| `--change-shell` | Make Zsh the login shell |

Examples:

```bash
# Preview everything without changing the machine
./install.sh --dry-run

# Install only the config links (no package downloads)
./install.sh --no-packages --no-extras --no-neovim-sync

# Also make Zsh the login shell
./install.sh --no-packages --no-extras --no-neovim-sync --change-shell
```

## Existing files and repeat runs

The installer is idempotent: links that already point to this folder are left
alone. Conflicting files or directories are moved to a timestamped folder under
`~/.dotfiles-backup/`; they are never deleted.

These links are created:

- `~/.bashrc` -> `bash/.bashrc`
- `~/.profile` -> `bash/.profile`
- `~/.gitconfig` -> `git/.gitconfig`
- `~/.config/kitty` -> `kitty/`
- `~/.config/nvim` -> `nvim/`
- `~/.tmux.conf` -> `tmux/.tmux.conf`
- `~/.zshrc` -> `zsh/.zshrc`
- `~/.zprofile` -> `zsh/.zprofile`

Machine-specific Git settings can go in `~/.gitconfig_local`. Bash and Zsh
machine-specific settings can go in `~/.bashrc_local`, `~/.zshrc.local`, and
`~/.zprofile.local`.

## Python and Django in Neovim

The Neovim configuration provides:

- Ruff import organization followed by formatting whenever a Python buffer is
  written with `:w`;
- djLint formatting for Django templates detected as `htmldjango`;
- BasedPyright completion and type checking with automatic `.venv`, `venv`, or
  `env` interpreter detection;
- Ruff diagnostics and code actions;
- targeted filtering of BasedPyright false positives for Django's dynamically
  generated model attributes, without weakening diagnostics in non-Django
  Python projects;
- a Django-only Ruff exception for declarative metadata in conventional
  framework modules, while retaining normal Ruff behavior in other projects;
- Django template and HTML language-server support; and
- Python and Django Treesitter highlighting.

Format-on-save is deliberately limited to Python and Django templates. It does
not change the C/C++ competitive-programming save behavior.

The installer restores the plugins, installs every configured Treesitter parser
synchronously, and then runs Mason synchronously. It verifies the parsers and
that `ruff`, `basedpyright-langserver`, `djlsp`, and `djlint` were installed
before reporting success. On later Neovim starts, the configured Treesitter and
Mason installers also repair missing components automatically.

The installer also performs save smoke tests: an intentionally unformatted
Python file must be organized and formatted by `:w`, while an intentionally
unformatted C++ file must remain byte-for-byte unchanged.

Useful Neovim commands:

| Command | Purpose |
| --- | --- |
| `:ConformInfo` | Show the formatter selected for the current buffer |
| `:LspInfo` | Show attached language servers |
| `:FormatDisable` | Disable format-on-save for the current buffer |
| `:FormatDisable!` | Disable format-on-save for the current session |
| `:FormatEnable` | Re-enable format-on-save |

## After installation

Open a new terminal, then verify the main tools:

```bash
nvim --version
deno --version
git config --global --get user.name
git config --global --get user.email
nvim --headless -i NONE \
  '+lua print(vim.fn.stdpath("data")); print(vim.fn.exepath("ruff"))' \
  '+qa!'
```

The final command should show `~/.local/share/nvim` and a Ruff executable under
`~/.local/share/nvim/mason/bin/`.

If Neovim was already open during installation, close every Neovim process and
start it again. An existing process cannot reload a changed XDG data directory.
If a VS Code integrated terminal still contains the old Snap path, reload the
shell first:

```bash
source ~/.zshrc
```

Inside Neovim, this command should then report the normal data directory:

```vim
:lua print(vim.fn.stdpath("data"))
```

If a language tool is ever missing, repair the declared Mason tools with:

```bash
nvim --headless -i NONE '+MasonToolsInstallSync' '+qa!'
```

If syntax highlighting is missing, install and verify all declared Treesitter
parsers with:

```bash
nvim --headless -i NONE '+TSInstallAllSync' '+qa!'
```

## Caps Lock as Escape in VSCodeVim

The installer includes the `vscodevim.vim` extension and configures GNOME so
Caps Lock sends Escape. Existing `caps:escape` or `caps:swapescape` settings are
preserved. VS Code is configured with `"keyboard.dispatch": "keyCode"` so it
honors the Linux XKB remap.

After installation, close every VS Code window and start VS Code again. Check
the active GNOME mapping with:

```bash
gsettings get org.gnome.desktop.input-sources xkb-options
```

If you selected `--change-shell`, log out and sign back in before checking the
new login shell with `printf '%s\n' "$SHELL"`.

## Authentication and private data

No private keys, access tokens, API keys, or passwords are stored or copied by
this repository. That is intentional. On a fresh machine you still need to:

1. Generate or securely restore your SSH key, then optionally copy
   `ssh/config.example` to `~/.ssh/config` and run `chmod 600 ~/.ssh/config`.
2. Add the public key to GitHub and test it with `ssh -T git@github.com`.
3. Sign in to GitHub Copilot from Neovim if you use it.
4. Configure Ollama and its `qwen2.5:latest` model if you use CodeCompanion.

Never commit private SSH keys or machine-specific secrets to this repository.

## Updating and recovery

When this folder is a Git clone, update it with `git pull` from inside the
folder. Because the installed configs are symbolic links, tracked config
updates take effect immediately.

If an old config was replaced during installation, recover it from the newest
timestamped directory under `~/.dotfiles-backup/`.

## Repository contents

- `bash/`, `zsh/`: interactive and login-shell configuration
- `git/`: Git identity and defaults
- `kitty/`, `tmux/`, `nvim/`: terminal and editor configuration
- `cp/`: competitive-programming template
- `packages/`: APT, Snap, and Flatpak manifests
- `vscode/`: VS Code extension manifest
- `ssh/config.example`: non-secret example only
