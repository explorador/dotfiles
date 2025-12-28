#!/bin/bash

# NVM (Node Version Manager) installation

# Check if NVM is already installed
if [ -d "$HOME/.nvm" ]; then
    echo "NVM is already installed"
    return 0 2>/dev/null || exit 0
fi

echo "Installing NVM..."
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash

# Source NVM immediately so it's available
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

echo "NVM installation complete!"
