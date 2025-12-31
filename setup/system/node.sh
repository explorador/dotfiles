#!/bin/bash

# Node.js installation via Volta

require_command "volta" || return 0

echo "Installing Node.js via Volta..."
volta install node

echo "Node.js installed!"
