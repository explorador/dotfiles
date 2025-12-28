#!/bin/bash

# Safari configuration
# Enables developer menu

# Open Safari apps
open "/Applications/Safari.app" 2>/dev/null
open "/Applications/Safari Technology Preview.app" 2>/dev/null
sleep 3

# Close apps
killall "Safari" &> /dev/null
killall "Safari Technology Preview" &> /dev/null
sleep 1

# Enable developer menu in Safari
defaults write com.apple.Safari IncludeDevelopMenu -bool true

# Enable developer menu in Safari Technology Preview
defaults write com.apple.SafariTechnologyPreview.SandboxBroker ShowDevelopMenu -bool true
