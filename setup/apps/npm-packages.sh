#!/bin/bash

# Global NPM packages installation

# Check if npm is available
if ! command -v npm &> /dev/null; then
    echo "npm not installed, skipping global packages"
    return 0 2>/dev/null || exit 0
fi

echo "Installing global npm packages..."
npm i -g contentful-cli expo-cli pa11y vnu-jar svgo

echo "NPM packages installed!"
