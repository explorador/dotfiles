#!/bin/bash

# TinyPNG4Mac configuration
# Sets API key

APP_PATH="/Applications/TinyPNG4Mac.app"

require_app "$APP_PATH" "TinyPNG4Mac" || return 0

# Open TinyPNG website to get API key
open -a "Firefox Developer Edition" https://tinyjpg.com 2>/dev/null || open https://tinyjpg.com

echo ""
print_warning "Get your TinyPNG API key from the website"
read -p "Enter TinyPNG API key: " tinyPNG

init_app_preferences "$APP_PATH" "TinyPNG4Mac"

# Set API Key
defaults write com.kyleduo.tinypngmac saved_api_key -string "$tinyPNG"
defaults write com.kyleduo.tinypngmac replace -bool true
