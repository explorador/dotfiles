#!/bin/bash

# SnippetsLab configuration
# Sets editor theme, active languages, and enables iCloud sync

SNIPPETSLAB_APP="/Applications/SnippetsLab.app"

# Check if SnippetsLab is installed
if [ ! -d "$SNIPPETSLAB_APP" ]; then
    echo "SnippetsLab not installed, skipping"
    return 0 2>/dev/null || exit 0
fi

# Open app
open "$SNIPPETSLAB_APP"
sleep 3

# Close app
killall "SnippetsLab" &> /dev/null
sleep 1

# Set editor theme
defaults write com.renfei.SnippetsLab "User EditorTheme" -string "CodeRunner"

# Set active languages
defaults write com.renfei.SnippetsLab "User ActiveLanguages" -array \
    "TextLexer" "CLexer" "CppLexer" "ObjectiveCLexer" "PythonLexer" \
    "PhpLexer" "JavascriptLexer" "MarkdownLexer" "SassLexer" "ScssLexer" \
    "BashLexer" "NginxConfLexer" "LiquidLexer"

# Enable iCloud Sync
defaults write com.renfei.SnippetsLab "Preferences EnableiCloudSync" -bool true
