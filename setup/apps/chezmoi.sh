#!/bin/bash

# Chezmoi dotfile manager setup

require_command "chezmoi" || return 0

# Create chezmoi config directory
mkdir -p ~/.config/chezmoi

# Copy default config file from repo
cp "$CONFIG_DIR/chezmoi.json" ~/.config/chezmoi/

# Pull dotfiles
echo "Updating dotfiles with chezmoi..."
chezmoi update

echo "Chezmoi setup complete!"
