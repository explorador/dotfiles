#!/bin/bash

# Git & GitHub CLI configuration
# Sets up git config, SSH keys, and GitHub authentication

email=$(get_user_email)

# Git configuration
git config --global color.ui true
git config --global user.name "Cristian Guerra"
git config --global user.email "$email"

# Generate SSH key if it doesn't exist
if [ ! -f ~/.ssh/id_rsa ]; then
  ssh-keygen -t rsa -b 4096 -C "$email"
fi

# Authenticate with GitHub CLI (uploads SSH key for authentication)
# Include admin:ssh_signing_key scope to allow uploading signing keys
echo "Authenticate with GitHub in your browser."
gh auth login --git-protocol ssh --scopes admin:ssh_signing_key

# Upload same SSH key for commit signing
gh ssh-key add ~/.ssh/id_rsa.pub --type signing --title "Signing key ($(hostname))"

# Configure Git to sign commits with SSH key
git config --global gpg.format ssh
git config --global user.signingkey ~/.ssh/id_rsa.pub
git config --global commit.gpgsign true

# Verify SSH connection
ssh -T git@github.com

wait_for_settings
