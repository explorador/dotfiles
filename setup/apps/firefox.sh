#!/bin/bash

# Firefox Developer Edition configuration
# Copies profile styles and sets default config

FIREFOX_APP="/Applications/Firefox Developer Edition.app"
DOTFILES="$HOME/.dotfiles"

# Check if Firefox is installed
if [ ! -d "$FIREFOX_APP" ]; then
    echo "Firefox Developer Edition not installed, skipping"
    return 0 2>/dev/null || exit 0
fi

# Open Firefox to create default profile
open "$FIREFOX_APP"
sleep 3

# Close app
killall "firefox" &> /dev/null
sleep 1

# Copy firefox profile styles
cp -R "$DOTFILES/config/apps/firefox/chrome" ~/Library/Application\ Support/Firefox/Profiles/*.dev-edition-default 2>/dev/null

# Copy firefox default config
cp "$DOTFILES/config/apps/firefox/autoconfig.js" "$FIREFOX_APP/Contents/Resources/defaults/pref/" 2>/dev/null
cp "$DOTFILES/config/apps/firefox/mozilla.cfg" "$FIREFOX_APP/Contents/Resources/" 2>/dev/null

sleep 1
