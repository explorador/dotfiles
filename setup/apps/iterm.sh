#!/bin/bash

# iTerm2 configuration
# Sets custom preferences directory

APP_PATH="/Applications/iTerm.app"

require_app "$APP_PATH" || return 0

init_app_preferences "$APP_PATH" "iTerm2"

# Point iTerm to custom preferences directory
defaults write com.googlecode.iterm2.plist PrefsCustomFolder -string "$CONFIG_DIR/apps/iTerm"
defaults write com.googlecode.iterm2.plist LoadPrefsFromCustomFolder -bool true

wait_for_settings
