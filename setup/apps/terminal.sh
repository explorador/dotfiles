#!/bin/bash

# Terminal.app configuration
# Sets One Dark theme

DOTFILES="$HOME/.dotfiles"

# Set theme by opening the terminal profile
open "$DOTFILES/config/apps/terminal/One Dark 1.0.1.terminal"
sleep 2

# Close app
killall "Terminal" &> /dev/null
sleep 1

# Set as default theme
defaults write com.apple.terminal "Default Window Settings" "One Dark 1.0.1"
defaults write com.apple.terminal "Startup Window Settings" "One Dark 1.0.1"
