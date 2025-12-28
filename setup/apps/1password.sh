#!/bin/bash

# 1Password CLI sign-in

# Check if 1Password CLI is installed
if ! command -v op &> /dev/null; then
    echo "1Password CLI not installed, skipping"
    return 0 2>/dev/null || exit 0
fi

# Get email from iCloud account (or prompt if not signed in)
email=$(/usr/libexec/PlistBuddy -c "print :Accounts:0:AccountID" ~/Library/Preferences/MobileMeAccounts.plist 2>/dev/null)
if [ -z "$email" ]; then
    read -p "Enter your email for 1Password: " email
fi

echo ""
tput setaf 3
echo "Signing into 1Password..."
tput sgr0
echo "Follow the prompts to authenticate."
echo ""

# Sign into 1Password
eval $(op signin my.1password.com "$email")
