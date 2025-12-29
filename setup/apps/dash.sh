#!/bin/bash

# Dash documentation browser configuration
# Sets Dropbox sync directory

APP_PATH="/Applications/Dash.app"

require_app "$APP_PATH" || return 0

init_app_preferences "$APP_PATH" "Dash"

# Set sync directory
defaults write com.kapeli.dashdoc syncFolderPath -string "$HOME/Dropbox/Dash"
