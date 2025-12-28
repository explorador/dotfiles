#!/bin/bash

# Jumpshare configuration
# Sets custom keyboard shortcuts

JUMPSHARE_APP="/Applications/Jumpshare.app"

# Check if Jumpshare is installed
if [ ! -d "$JUMPSHARE_APP" ]; then
    echo "Jumpshare not installed, skipping"
    return 0 2>/dev/null || exit 0
fi

# Open app
open "$JUMPSHARE_APP"
sleep 3

# Close app
killall "Jumpshare" &> /dev/null
sleep 1

# Take & Edit Screenshot shortcut
defaults write com.jumpshare.Jumpshare hotkeyannotation -dict \
    characters -int 4 \
    charactersIgnoringModifiers -string "\$" \
    keyCode -int 21 \
    modifierFlags -int 1179648

sleep 1
