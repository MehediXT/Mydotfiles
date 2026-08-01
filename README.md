# Dotfiles

This repository now keeps the important configuration files only. The shell installer and bootstrap scripts were removed so setup is fully manual and nothing in the repo will overwrite your config data automatically.

## What is kept here

- `bash/`: Bash login and interactive shell config.
- `git/`: Git defaults and identity settings.
- `kitty/`: Kitty terminal configuration.
- `nvim/`: Neovim configuration.
- `tmux/`: tmux configuration.
- `vscode/`: VS Code extension list.
- `zsh/`: Zsh configuration.
- `cp/`: Competitive programming template files.
- `packages/`: Package manifests for APT, Snap, and Flatpak.
- `ssh/config.example`: Example SSH config only, not private keys.

## Fresh Device Setup

1. Install the basic tools you need for manual setup.

```bash
sudo apt update
sudo apt install -y git curl ca-certificates build-essential software-properties-common
```

2. Clone the repository.

```bash
git clone https://github.com/MehediXT/Mydotfiles.git ~/.dotfiles
cd ~/.dotfiles
```

3. Create the target directories.

```bash
mkdir -p ~/.config ~/.local/bin ~/.ssh
```

4. Link the tracked config files into place. If a file already exists on your machine, back it up first instead of deleting it.

```bash
ln -sfn ~/.dotfiles/bash/.bashrc ~/.bashrc
ln -sfn ~/.dotfiles/bash/.profile ~/.profile
ln -sfn ~/.dotfiles/git/.gitconfig ~/.gitconfig
ln -sfn ~/.dotfiles/kitty ~/.config/kitty
ln -sfn ~/.dotfiles/nvim ~/.config/nvim
ln -sfn ~/.dotfiles/tmux/.tmux.conf ~/.tmux.conf
ln -sfn ~/.dotfiles/zsh/.zshrc ~/.zshrc
ln -sfn ~/.dotfiles/zsh/.zprofile ~/.zprofile
```

5. Install the packages you want from the manifests.

```bash
grep -vE '^[[:space:]]*#|^[[:space:]]*$' packages/apt.txt | xargs sudo apt install -y
grep -vE '^[[:space:]]*#|^[[:space:]]*$' packages/snap.txt | xargs -r -n1 sudo snap install
grep -vE '^[[:space:]]*#|^[[:space:]]*$' packages/flatpak.txt | xargs -r -n1 flatpak install -y flathub
```

6. Restore your VS Code extensions if you use VS Code.

```bash
grep -vE '^[[:space:]]*#|^[[:space:]]*$' vscode/extensions.txt | xargs -r -n1 code --install-extension
```

7. Copy your personal SSH config locally if needed.

```bash
cp ssh/config.example ~/.ssh/config
chmod 600 ~/.ssh/config
```

## Notes

- Do not store private SSH keys in this repository.
- Keep machine-specific secrets in your local home directory, not in Git.
- If you copy this repo to another machine, link the files again there instead of running any removed script.

## Common Paths

- `~/.bashrc` -> `bash/.bashrc`
- `~/.profile` -> `bash/.profile`
- `~/.gitconfig` -> `git/.gitconfig`
- `~/.config/kitty` -> `kitty/`
- `~/.config/nvim` -> `nvim/`
- `~/.tmux.conf` -> `tmux/.tmux.conf`
- `~/.zshrc` -> `zsh/.zshrc`
- `~/.zprofile` -> `zsh/.zprofile`
