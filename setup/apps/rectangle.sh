#!/bin/bash

# Rectangle window manager configuration
# Sets Spectacle-mode shortcuts

RECTANGLE_APP="/Applications/Rectangle.app"

# Check if Rectangle is installed
if [ ! -d "$RECTANGLE_APP" ]; then
    echo "Rectangle not installed, skipping"
    return 0 2>/dev/null || exit 0
fi

# Open Rectangle
open "$RECTANGLE_APP"

# Prompt for authorization
echo ""
tput setaf 3
echo "Rectangle needs Accessibility permissions."
tput sgr0
echo "Grant access when prompted, then press enter to continue."
read -p "Press enter once done"
sleep 3

# Close app
killall "Rectangle" &> /dev/null

# Set "Spectacle mode" shortcuts
defaults write com.knollsoft.Rectangle alternateDefaultShortcuts -bool false
# Set cycling behavior to "Spectacle mode"
defaults write com.knollsoft.Rectangle subsequentExecutionMode -int 0

# Open app again
open "$RECTANGLE_APP"

sleep 1
