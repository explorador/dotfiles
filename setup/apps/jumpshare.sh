#!/bin/bash

# Jumpshare configuration
# Sets custom keyboard shortcuts

APP_PATH="/Applications/Jumpshare.app"

require_app "$APP_PATH" || return 0

init_app_preferences "$APP_PATH" "Jumpshare"

# Take & Edit Screenshot shortcut
defaults write com.jumpshare.Jumpshare hotkeyannotation -dict \
    characters -int 4 \
    charactersIgnoringModifiers -string "\$" \
    keyCode -int 21 \
    modifierFlags -int 1179648

wait_for_settings
