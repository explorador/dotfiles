#!/bin/bash

# Git & GitHub CLI configuration
# Sets up git config, SSH keys, and GitHub authentication

# Get email from iCloud account (or prompt if not signed in)
email=$(/usr/libexec/PlistBuddy -c "print :Accounts:0:AccountID" ~/Library/Preferences/MobileMeAccounts.plist 2>/dev/null)
if [ -z "$email" ]; then
    read -p "Enter your email: " email
fi

# Git configuration
git config --global color.ui true
git config --global user.name "Cristian"
git config --global user.email "$email"

# Generate SSH key if it doesn't exist
if [ ! -f ~/.ssh/id_rsa ]; then
    ssh-keygen -t rsa -b 4096 -C "$email"
fi

# Authenticate with GitHub CLI (uploads SSH key for authentication)
echo "Authenticate with GitHub in your browser."
gh auth login --git-protocol ssh

# Upload same SSH key for commit signing
gh ssh-key add ~/.ssh/id_rsa.pub --type signing --title "Signing key ($(hostname))"

# Configure Git to sign commits with SSH key
git config --global gpg.format ssh
git config --global user.signingkey ~/.ssh/id_rsa.pub
git config --global commit.gpgsign true

# Verify SSH connection
ssh -T git@github.com

sleep 1
