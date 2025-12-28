#!/bin/bash

# Chezmoi dotfile manager setup

DOTFILES="$HOME/.dotfiles"

# Check if chezmoi is installed
if ! command -v chezmoi &> /dev/null; then
    echo "Chezmoi not installed, skipping"
    return 0 2>/dev/null || exit 0
fi

# Create chezmoi config directory
mkdir -p ~/.config/chezmoi

# Copy default config file from repo
cp "$DOTFILES/config/chezmoi.json" ~/.config/chezmoi/

# Pull dotfiles
echo "Updating dotfiles with chezmoi..."
chezmoi update

echo "Chezmoi setup complete!"
