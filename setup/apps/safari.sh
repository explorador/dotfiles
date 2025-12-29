#!/bin/bash

# Safari configuration - enables developer menu

configure_safari() {
    local app_path="$1"
    local app_name="$2"
    local domain="$3"

    # Initialize preferences
    init_app_preferences "$app_path" "$app_name"

    # Enable developer menu (SandboxBroker doesn't require Full Disk Access)
    defaults write "${domain}.SandboxBroker" ShowDevelopMenu -bool true

    # These require Full Disk Access for Terminal - suppress errors if not granted
    defaults write "$domain" IncludeDevelopMenu -bool true 2>/dev/null
    defaults write "$domain" WebKitDeveloperExtrasEnabledPreferenceKey -bool true 2>/dev/null
    defaults write "$domain" "${domain}.ContentPageGroupIdentifier.WebKit2DeveloperExtrasEnabled" -bool true 2>/dev/null
}

configure_safari "/Applications/Safari.app" "Safari" "com.apple.Safari"
configure_safari "/Applications/Safari Technology Preview.app" "Safari Technology Preview" "com.apple.SafariTechnologyPreview"

# Add context menu item for Web Inspector in web views (global, applies to all)
defaults write NSGlobalDomain WebKitDeveloperExtras -bool true
