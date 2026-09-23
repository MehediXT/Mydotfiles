# My dotfiles

This repository contains my personal Linux desktop and development setup. It
is built around a keyboard-driven Hyprland session, a customized terminal, and
Neovim for programming. I keep the files here so I can reproduce the parts of
my setup I care about and track changes with Git.

> [!NOTE]
> These are personal configuration files, not a universal installer. Some
> settings are specific to my hardware and workflow, especially the monitor,
> NVIDIA, OpenRGB, and Hyprland settings. Review a file before using it on a
> different machine.

## What I use

| Area | Tools | What I use them for |
| --- | --- | --- |
| Window manager | Hyprland | Tiling windows, workspaces, gestures, window rules, transparency, blur, and keyboard-driven navigation |
| Desktop shell | Noctalia | Application launcher, lock screen, settings panel, and shared desktop colors |
| Terminal | Kitty | My main terminal, with the Dracula color scheme and AtkynsonMono Nerd Font |
| Shell | Zsh, Oh My Zsh, Spaceship | Interactive shell, prompt, Git information, autosuggestions, and syntax highlighting |
| Multiplexer | tmux | Persistent terminal sessions, panes, large scrollback, mouse support, and vi-style copy mode |
| Main editor | Neovim + NvChad | Programming, LSP, completion, formatting, Treesitter highlighting, code running, and competitive programming |
| GUI editor | VS Code | A secondary editor with Vim controls, autosave, C/C++ tools, Prettier, YAML support, and a Zsh terminal |
| File manager | Thunar | Graphical file browsing, launched with `Super+E` |
| Browser | Brave first, with fallbacks | The launcher tries Brave, Firefox, Zen Browser, Vivaldi, and LibreWolf in that order when available |
| Screenshots | Hyprshot, Grim, Slurp, Satty | Region, window, and monitor captures plus screenshot annotation |
| Screen annotation | Wayscriber | Drawing over the desktop, whiteboards, highlights, notes, and annotated captures |
| Audio and media | EasyEffects, Quod Libet, mpv, Playerctl, Pamixer | Audio processing, music, video, media keys, and volume control |
| Appearance | Dracula, Bibata, Nerd Font | Terminal colors, cursor theme, and icon-capable monospace text |
| System information | Neofetch | A small system summary whenever an interactive Zsh session starts |
| RGB control | OpenRGB | Shell aliases for controlling the RAM, GPU, and mouse lighting |

## Desktop workflow

The Hyprland configuration is split into small Lua modules under
`.config/hypr/` for monitors, input, keybindings, startup programs, window
rules, animation, and theming. It uses a dwindle layout with small gaps,
rounded corners, blur, snapping, and 90% window opacity. Games are kept fully
opaque, and picture-in-picture windows are floated and pinned.

The current monitor profile is `1920x1080@100`. NVIDIA-specific environment
settings are enabled in `startup.lua`, so that file should be adjusted before
using the config with another GPU. Startup services include Noctalia,
Wayscriber, clipboard persistence, the desktop portals, GNOME Keyring, and
EasyEffects.

Important shortcuts:

| Shortcut | Action |
| --- | --- |
| `Super+Return` | Open Kitty |
| `Super+E` | Open Thunar |
| `Super+C` | Open VS Code |
| `Super+B` | Open the first available browser |
| `Super+D` | Toggle the Noctalia launcher |
| `Super+L` | Lock the screen |
| `Super+Q` | Close the active window |
| `Super+W` / `Super+F` | Toggle floating / fullscreen |
| `Super+1` ... `Super+0` | Switch to workspace 1 ... 10 |
| `Super+Shift+1` ... `Super+Shift+0` | Move a window to a workspace |
| `Super+Arrow` | Move focus |
| `Super+Shift+Arrow` | Resize the active window |
| `Print` | Capture a region |
| `Super+Print` | Capture a window |
| `Alt+Print` | Capture a monitor |
| `Shift+Print` | Capture and annotate with Satty |
| `Super+Shift+A` | Show or hide Wayscriber |
| `Super+Ctrl+A` | Toggle Wayscriber passthrough |

See `.config/hypr/keybind.lua` for the complete keymap and
`.config/wayscriber/README.md` for the annotation shortcuts.

## Development setup

### Neovim

My main editor is Neovim with NvChad and `lazy.nvim`. The configuration
includes:

- LSP support for C/C++, Python, Django templates, HTML, and Rust;
- BasedPyright for Python type checking and virtual-environment detection;
- Ruff for Python diagnostics, import organization, and formatting;
- djLint and Django Template LSP for Django templates;
- Conform for project-aware formatting across Python, C/C++, web languages,
  Lua, Rust, shell, SQL, Markdown, and other configured file types;
- Treesitter parsers for C, C++, Python, Lua, Vim, Markdown, HTML, Django,
  CSS, JavaScript, TypeScript, and TSX;
- GitHub Copilot suggestions, accepted with `Ctrl+Y` in insert mode;
- CodeCompanion connected to a local Ollama `qwen2.5:latest` model;
- Code Runner and CompetiTest for quickly compiling programs and checking
  competitive-programming test cases;
- Markdown rendering, CSV viewing, Quarto support, and Rustaceanvim; and
- a reusable C++ competitive-programming template and snippets.

The formatter selection prefers Ruff for Python and djLint for Django
templates. C formatting is available only when the project contains a
`.cformat` file, while C++ uses ClangFormat. Other languages use the formatter
declared in the Conform configuration. Automatic format-on-save is currently
disabled, so these rules apply when formatting is invoked from Neovim.

Useful keys and commands:

| Key or command | Purpose |
| --- | --- |
| `Space+w` / `Space+q` | Save / quit |
| `jj` | Leave insert mode |
| `F5` | Compile and run interactively |
| `F6` | Run CompetiTest cases |
| `Space+cc` | Toggle CodeCompanion chat |
| `Space+cf` | Run the current file |
| `:ConformInfo` | Show formatter information |
| `:LspInfo` | Show attached language servers |
| `:MasonToolsInstallSync` | Install the declared Python and Django tools |

CodeCompanion requires Ollama and the configured model to be installed
separately. Copilot also requires signing in to GitHub.

### Shell and terminal

Zsh is my primary interactive shell. Oh My Zsh loads the Git,
`zsh-autosuggestions`, and `zsh-syntax-highlighting` plugins, while Spaceship
shows the time, user, directory, and Git status. Volta is used for Node.js tool
management, and `~/.local/bin` and Turso are added to `PATH`.

Kitty uses the Dracula theme and AtkynsonMono Nerd Font. tmux changes the
prefix from `Ctrl+B` to `Ctrl+A`, numbers windows and panes from 1, enables the
mouse, uses vi-style copy mode, and provides `|` and `-` bindings for splits.

Bash remains available as a simpler fallback shell. Both shell setups support
untracked local override files so machine-specific settings do not need to be
committed.

## Package manifests

The files in `packages/` record a portable Ubuntu/Debian-oriented development
baseline. It includes compilers and build tools, Git, curl, fd, ripgrep, fzf,
JQ, Kitty, tmux, Zsh, Python, Node.js, ShellCheck, shfmt, and common archive and
clipboard utilities. `packages/snap.txt` currently records Neovim as a classic
Snap package; the Flatpak manifest is currently empty.

These manifests do not contain every application referenced by the Hyprland
configuration. Desktop-specific tools such as Hyprland, Noctalia, Wayscriber,
Thunar, screenshot utilities, media tools, OpenRGB, Ollama, browsers, and VS
Code must be installed separately when needed.

## Using these dotfiles

Clone the repository to a permanent location:

```bash
git clone https://github.com/MehediXT/Mydotfiles.git ~/.dotfiles
cd ~/.dotfiles
```

Run the installer as your normal user. It installs the package manifests,
creates symlinks, installs the Zsh components, Nerd Font, Deno, and a compatible
Tree-sitter CLI, and bootstraps Neovim. Existing files are moved to a timestamped
directory under `~/.dotfiles-backup/` before they are replaced.

```bash
./setup.sh --dry-run
./setup.sh
```

The installer targets Ubuntu/Debian. Use `./setup.sh --help` to skip package,
shell, Neovim, or VS Code setup, or to opt into changing the login shell. Do not
run the whole script with `sudo`; it requests `sudo` only for system packages.
Because the generated symbolic links point into the clone, moving or deleting
the repository later will break them.

The Hyprland configuration is linked but its desktop applications are not
installed automatically. Review `monitors.lua` and `startup.lua` before starting
Hyprland on hardware with a different monitor or GPU.

VS Code settings, keybindings, and the extension list are kept in `vscode/`.
When the `code` CLI is available, the installer links the settings and restores
the listed extensions. Pass `--skip-vscode` to leave the existing VS Code setup
untouched.

## Local settings and private data

Machine-specific Git settings can be placed in `~/.gitconfig_local`. The shell
configs also load these optional local files:

- `~/.bashrc_local`
- `~/.zprofile.local`
- `~/.zsh_aliases`

Private keys, passwords, API keys, and access tokens are intentionally not
stored here. `ssh/config.example` is only a non-secret template. On a new
machine, SSH keys, Copilot authentication, Ollama models, and other credentials
must be restored separately.

## Repository layout

| Path | Contents |
| --- | --- |
| `.config/hypr/` | Hyprland desktop, startup, theme, scripts, and keybindings |
| `.config/kitty/` | Kitty terminal and Dracula theme |
| `.config/neofetch/` | Terminal system summary and custom ASCII art |
| `.config/nvim/` | NvChad-based Neovim configuration and plugin lockfile |
| `.config/wayscriber/` | Desktop annotation configuration and quick guide |
| `bash/` and `zsh/` | Interactive and login shell configuration |
| `tmux/` | tmux configuration |
| `git/` | Git identity, defaults, aliases, and local include |
| `cp/` | Competitive-programming C++ template |
| `packages/` | APT, Snap, and Flatpak package manifests |
| `vscode/` | VS Code settings, keybindings, and extension list |
| `ssh/` | Non-secret SSH configuration example |
| `setup.sh` | Safe, rerunnable Ubuntu/Debian setup and Neovim bootstrap |
