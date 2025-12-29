#!/bin/bash

# Safari configuration - enables developer menu

# Open Safari apps to initialize preferences
init_app_preferences "/Applications/Safari.app" "Safari"
init_app_preferences "/Applications/Safari Technology Preview.app" "Safari Technology Preview"

# Enable developer menu in Safari
defaults write com.apple.Safari IncludeDevelopMenu -bool true

# Enable developer menu in Safari Technology Preview
defaults write com.apple.SafariTechnologyPreview.SandboxBroker ShowDevelopMenu -bool true
