#!/bin/bash

# Rectangle window manager configuration
# Sets Spectacle-mode shortcuts

APP_PATH="/Applications/Rectangle.app"

require_app "$APP_PATH" || return 0

# Open Rectangle
open "$APP_PATH"

# Prompt for authorization
echo ""
print_warning "Rectangle needs Accessibility permissions."
echo "Grant access when prompted, then press enter to continue."
read -p "Press enter once done"
sleep "$DELAY_APP_INIT"

close_app "Rectangle"

# Set "Spectacle mode" shortcuts
defaults write com.knollsoft.Rectangle alternateDefaultShortcuts -bool false
defaults write com.knollsoft.Rectangle subsequentExecutionMode -int 0

# Open app again
open "$APP_PATH"

wait_for_settings
