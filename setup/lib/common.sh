#!/bin/bash

# Common utilities and constants for dotfiles setup
# This file should be sourced by all setup scripts

# Guard against multiple sourcing
[[ -n "$_COMMON_SH_LOADED" ]] && return 0
_COMMON_SH_LOADED=1

#=============================================================================
# PATH CONSTANTS (single source of truth)
#=============================================================================

readonly DOTFILES_ROOT="$HOME/.dotfiles"
readonly SETUP_DIR="$DOTFILES_ROOT/setup"
readonly CONFIG_DIR="$DOTFILES_ROOT/config"

#=============================================================================
# TIMING CONSTANTS
#=============================================================================

readonly DELAY_APP_INIT=3      # Seconds to wait for app to initialize
readonly DELAY_APP_CLOSE=1     # Seconds to wait after killing app
readonly DELAY_SETTINGS=1      # Seconds to wait for defaults to apply

#=============================================================================
# COLOR/FORMATTING HELPERS
#=============================================================================

color_reset()   { tput sgr0; }
color_cyan()    { tput setaf 6; }
color_yellow()  { tput setaf 3; }
color_green()   { tput setaf 2; }
color_red()     { tput setaf 1; }
color_gray()    { tput setaf 8; }
color_magenta() { tput setaf 5; }
color_white()   { tput setaf 7; }
text_bold()     { tput bold; }
text_reverse()  { tput smso; }
text_reverse_off() { tput rmso; }

#=============================================================================
# APP AVAILABILITY CHECKS
#=============================================================================

# Check if a macOS application is installed
# Usage: require_app "/Applications/App.app" || return 0
# Returns: 0 if installed, 1 if not (with message)
require_app() {
    local app_path="$1"
    local app_name="${2:-$(basename "$app_path" .app)}"

    if [ ! -d "$app_path" ]; then
        echo "$app_name not installed, skipping"
        return 1
    fi
    return 0
}

# Check if a command-line tool is installed
# Usage: require_command "brew" || return 0
require_command() {
    local cmd="$1"
    local tool_name="${2:-$cmd}"

    if ! command -v "$cmd" &> /dev/null; then
        echo "$tool_name not installed, skipping"
        return 1
    fi
    return 0
}

#=============================================================================
# APP LIFECYCLE HELPERS
#=============================================================================

# Open an app, wait for initialization, then close it
# This creates default preferences files
# Usage: init_app_preferences "/Applications/App.app" "ProcessName"
init_app_preferences() {
    local app_path="$1"
    local process_name="${2:-$(basename "$app_path" .app)}"

    open "$app_path"
    sleep "$DELAY_APP_INIT"
    killall "$process_name" &> /dev/null
    sleep "$DELAY_APP_CLOSE"
}

# Close an app by process name
# Usage: close_app "AppName"
close_app() {
    local process_name="$1"
    killall "$process_name" &> /dev/null
    sleep "$DELAY_APP_CLOSE"
}

# Wait for settings to apply (after defaults write)
# Usage: wait_for_settings
wait_for_settings() {
    sleep "$DELAY_SETTINGS"
}

#=============================================================================
# USER INFORMATION
#=============================================================================

# Get primary email from iCloud account, or prompt user
# Usage: email=$(get_user_email)
get_user_email() {
    local email
    email=$(/usr/libexec/PlistBuddy -c "print :Accounts:0:AccountID" \
        ~/Library/Preferences/MobileMeAccounts.plist 2>/dev/null)

    if [ -z "$email" ]; then
        read -p "Enter your email: " email
    fi
    echo "$email"
}

#=============================================================================
# OUTPUT FORMATTING
#=============================================================================

# Print a section header
# Usage: print_header "Section Name"
print_header() {
    local title="$1"
    echo ""
    color_cyan
    echo "=== $title ==="
    color_reset
    echo ""
}

# Print a subsection header
# Usage: print_subheader "Subsection"
print_subheader() {
    local title="$1"
    echo ""
    color_magenta
    echo "--- $title ---"
    color_reset
}

# Print a warning message
# Usage: print_warning "Something needs attention"
print_warning() {
    local message="$1"
    color_yellow
    echo "$message"
    color_reset
}

# Print a banner (reversed text)
# Usage: print_banner "Running setup"
print_banner() {
    local text="$1"
    color_white
    text_reverse
    echo " $text "
    text_reverse_off
    color_reset
}
