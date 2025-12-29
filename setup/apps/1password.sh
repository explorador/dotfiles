#!/bin/bash

# 1Password CLI sign-in

require_command "op" "1Password CLI" || return 0

email=$(get_user_email)

echo ""
print_warning "Signing into 1Password..."
echo "Follow the prompts to authenticate."
echo ""

# Sign into 1Password
eval $(op signin my.1password.com "$email")
