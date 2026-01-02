#!/bin/bash

# Node.js installation via Volta

require_command "volta" || return 0

gum_spin "Installing Node.js via Volta..." volta install node

gum_status "success" "Node.js installed!"
