#!/bin/bash

# Homebrew installation and package setup

print_banner "Running Homebrew setup"

# Install Homebrew if not present
if ! command -v brew &> /dev/null; then
    echo "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

    # Add brew to PATH for Apple Silicon Macs
    if [[ -f "/opt/homebrew/bin/brew" ]]; then
        eval "$(/opt/homebrew/bin/brew shellenv)"
    fi
fi

# Export HOMEBREW_MACHINE environment variable for Brewfile conditional logic
# (Homebrew only passes HOMEBREW_* prefixed vars to its Ruby environment)
machine_type=$(get_machine_type)
if [ "$machine_type" = "work" ]; then
    export HOMEBREW_MACHINE=work
fi

# Install all packages from Brewfile using brew bundle
echo "Installing packages from Brewfile..."
brew bundle --file="$DOTFILES_ROOT/Brewfile"

echo "Homebrew setup complete!"
