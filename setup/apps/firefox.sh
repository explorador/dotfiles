#!/bin/bash

# Firefox Developer Edition configuration
# Copies profile styles and sets default config

APP_PATH="/Applications/Firefox Developer Edition.app"

require_app "$APP_PATH" "Firefox Developer Edition" || return 0

init_app_preferences "$APP_PATH" "firefox"

# Copy firefox profile styles
cp -R "$CONFIG_DIR/apps/firefox/chrome" ~/Library/Application\ Support/Firefox/Profiles/*.dev-edition-default 2>/dev/null

# Copy firefox default config
cp "$CONFIG_DIR/apps/firefox/autoconfig.js" "$APP_PATH/Contents/Resources/defaults/pref/" 2>/dev/null
cp "$CONFIG_DIR/apps/firefox/mozilla.cfg" "$APP_PATH/Contents/Resources/" 2>/dev/null

wait_for_settings
