#!/bin/bash

# SnippetsLab configuration
# Sets editor theme, active languages, and enables iCloud sync

APP_PATH="/Applications/SnippetsLab.app"

require_app "$APP_PATH" || return 0

init_app_preferences "$APP_PATH" "SnippetsLab"

# Set editor theme
defaults write com.renfei.SnippetsLab "User EditorTheme" -string "CodeRunner"

# Set active languages
defaults write com.renfei.SnippetsLab "User ActiveLanguages" -array \
    "TextLexer" "CLexer" "CppLexer" "ObjectiveCLexer" "PythonLexer" \
    "PhpLexer" "JavascriptLexer" "MarkdownLexer" "SassLexer" "ScssLexer" \
    "BashLexer" "NginxConfLexer" "LiquidLexer"

# Enable iCloud Sync
defaults write com.renfei.SnippetsLab "Preferences EnableiCloudSync" -bool true
