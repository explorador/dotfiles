#!/bin/bash

# Terminal.app configuration
# Sets One Dark theme

# Set theme by opening the terminal profile
open "$CONFIG_DIR/apps/terminal/One Dark 1.0.1.terminal"
sleep 2

close_app "Terminal"

# Set as default theme
defaults write com.apple.terminal "Default Window Settings" "One Dark 1.0.1"
defaults write com.apple.terminal "Startup Window Settings" "One Dark 1.0.1"
