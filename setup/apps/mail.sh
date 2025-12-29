#!/bin/bash

# Mail.app configuration
# Note: Mail is sandboxed - requires Full Disk Access to modify defaults

# Check for Full Disk Access
if ! plutil -lint /Library/Preferences/com.apple.TimeMachine.plist >/dev/null 2>&1; then
    echo ""
    print_warning "Terminal needs Full Disk Access to configure Mail."
    echo "Add Terminal to: System Settings > Privacy & Security > Full Disk Access"
    open "x-apple.systempreferences:com.apple.preference.security?Privacy_AllFiles"
    read -p "Press enter after granting access and restarting Terminal"
fi

# Ensure Mail is closed before modifying defaults
close_app "Mail"

# Disable "Use dark backgrounds for messages"
defaults write com.apple.mail ViewMessagesWithDarkBackgrounds -bool false
# Enable "Show most recent message at the top"
defaults write com.apple.mail ConversationViewSortDescending -bool true
# Enable "Use the same message format as the original message" (Preferences > Composing)
defaults write com.apple.mail AutoReplyFormat -bool true
# Disable "Increase quote level" (Preferences > Composing)
defaults write com.apple.mail SupressQuoteBarsInComposeWindows -bool false

wait_for_settings
