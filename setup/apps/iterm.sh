#!/bin/bash

# iTerm2 configuration
# Sets custom preferences directory

ITERM_APP="/Applications/iTerm.app"
DOTFILES="$HOME/.dotfiles"

# Check if iTerm is installed
if [ ! -d "$ITERM_APP" ]; then
    echo "iTerm not installed, skipping"
    return 0 2>/dev/null || exit 0
fi

# Open app to create preferences
open "$ITERM_APP"
sleep 3

# Close app
killall "iTerm2" &> /dev/null
sleep 1

# Specify iTerm preferences directory
defaults write com.googlecode.iterm2.plist PrefsCustomFolder -string "$DOTFILES/config/apps/iTerm"
# Tell iTerm2 to use the custom preferences in the directory
defaults write com.googlecode.iterm2.plist LoadPrefsFromCustomFolder -bool true

sleep 1
