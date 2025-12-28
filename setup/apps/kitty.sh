#!/bin/bash

# Kitty terminal icon replacement
# Replaces default icon with custom dark icon

KITTY_APP="/Applications/kitty.app"
DOTFILES="$HOME/.dotfiles"

# Check if Kitty is installed
if [ ! -d "$KITTY_APP" ]; then
    echo "Kitty not installed, skipping"
    return 0 2>/dev/null || exit 0
fi

# Replace default icon with custom dark icon
cp "$DOTFILES/config/apps/kitty/kitty-dark.icns" "$KITTY_APP/Contents/Resources/kitty.icns"

# Touch app bundle to invalidate cache
touch "$KITTY_APP"

# Clear icon cache and restart Dock
sudo rm -rf /Library/Caches/com.apple.iconservices.store 2>/dev/null
killall Dock

sleep 1
