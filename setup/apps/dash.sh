#!/bin/bash

# Dash documentation browser configuration
# Sets Dropbox sync directory

DASH_APP="/Applications/Dash.app"

# Check if Dash is installed
if [ ! -d "$DASH_APP" ]; then
    echo "Dash not installed, skipping"
    return 0 2>/dev/null || exit 0
fi

# Open app
open "$DASH_APP"
sleep 3

# Close app
killall "Dash" &> /dev/null
sleep 1

# Set sync directory
defaults write com.kapeli.dashdoc syncFolderPath -string "$HOME/Dropbox/Dash"
