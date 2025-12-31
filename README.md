# Personal Dotfiles

![OS Version](https://img.shields.io/badge/MacOS-Tahoe-white?style=flat&logo=apple&labelColor=1c1c1e)
![Maintenance](https://img.shields.io/maintenance/yes/2026?style=flat)

## 🚀 Getting started

1. Install command line developer tools

```
xcode-select --install
```

2. Temporary enable "Full Disk Access" for the terminal app

```
/usr/bin/open 'x-apple.systempreferences:com.apple.preference.security?Privacy_AllFiles'
```

3. Clone this repo

```
git clone https://github.com/explorador/dotfiles.git ~/.dotfiles
```

4. Run installer

```
sh ~/.dotfiles/installer.sh
```

## Structure

```
Brewfile        # Homebrew packages and casks
config/         # Dotfiles managed by chezmoi
setup/
  system/       # System setup (macOS, Homebrew, Node)
  apps/         # App configuration scripts
  lib/          # Shared utilities
```

## How it works

1. **System setup** runs first: macOS preferences, Homebrew (installs `Brewfile`), Node via Volta
2. **App setup** runs tracked scripts from `setup/apps/` - each app is configured once and skipped on re-runs
3. **Dotfiles** are managed by [chezmoi](https://chezmoi.io) from `config/`

Run `setup/main.sh --status` to see what's configured.

## Shell customizations

Custom functions and aliases are in `config/dot_config/zsh/`:

- `functions.zsh` - utility functions and the `proj` command
- `aliases.zsh` - dev and tmux aliases

Run `myfunctions` to list all available custom functions.
