#!/bin/bash

# TinyPNG4Mac configuration
# Sets API key

TINYPNG_APP="/Applications/TinyPNG4Mac.app"

# Check if TinyPNG is installed
if [ ! -d "$TINYPNG_APP" ]; then
    echo "TinyPNG4Mac not installed, skipping"
    return 0 2>/dev/null || exit 0
fi

# Open TinyPNG website to get API key
open -a "Firefox Developer Edition" https://tinyjpg.com 2>/dev/null || open https://tinyjpg.com

echo ""
tput setaf 3
echo "Get your TinyPNG API key from the website"
tput sgr0
read -p "Enter TinyPNG API key: " tinyPNG

# Open app
open "$TINYPNG_APP"
sleep 3

# Close app
killall "TinyPNG4Mac" &> /dev/null
sleep 1

# Set API Key
defaults write com.kyleduo.tinypngmac saved_api_key -string "$tinyPNG"
# Replace Origin?
defaults write com.kyleduo.tinypngmac replace -bool true
