#!/bin/bash

# Global NPM packages installation

require_command "npm" || return 0

echo "Installing global npm packages..."
npm i -g contentful-cli expo-cli pa11y vnu-jar svgo

echo "NPM packages installed!"
