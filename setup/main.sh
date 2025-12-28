#!/bin/bash

# Main orchestrator script for dotfiles setup

DOTFILES="$HOME/.dotfiles"
SETUP_DIR="$DOTFILES/setup"

# Source helper functions
source "$SETUP_DIR/lib/tracking.sh"

# Parse arguments
MODE="${1:---full}"

# Countdown function for reboot
countdown() {
    secs=$1
    shift
    msg=$@
    while [ $secs -gt 0 ]; do
        printf "\r\033[K$msg %.d seconds" $((secs--))
        sleep 1
    done
    echo
}

# Select specific app to configure
select_app() {
    echo ""
    tput setaf 6
    echo "=== Select App to Configure ==="
    tput sgr0
    echo ""

    local i=1
    for app in "${ALL_APPS[@]}"; do
        if is_configured "$app"; then
            tput setaf 8
            printf "%2d. %s (configured)\n" "$i" "$app"
            tput sgr0
        else
            printf "%2d. %s\n" "$i" "$app"
        fi
        ((i++))
    done

    echo ""
    read -p "Enter number (or 'all' to reconfigure all): " selection

    if [ "$selection" = "all" ]; then
        for app in "${ALL_APPS[@]}"; do
            if [ "$app" = "nvm" ]; then
                run_forced "$app" "$SETUP_DIR/system/nvm.sh"
            else
                run_forced "$app" "$SETUP_DIR/apps/${app}.sh"
            fi
        done
    elif [[ "$selection" =~ ^[0-9]+$ ]] && [ "$selection" -ge 1 ] && [ "$selection" -le "${#ALL_APPS[@]}" ]; then
        local selected_app="${ALL_APPS[$((selection-1))]}"
        if [ "$selected_app" = "nvm" ]; then
            run_forced "$selected_app" "$SETUP_DIR/system/nvm.sh"
        else
            run_forced "$selected_app" "$SETUP_DIR/apps/${selected_app}.sh"
        fi
    else
        echo "Invalid selection"
    fi
}

# Run full setup
run_full_setup() {
    echo ""
    tput setaf 6
    echo "=== Full Setup ==="
    tput sgr0
    echo ""

    # Close System Preferences
    osascript -e 'tell application "System Preferences" to quit' 2>/dev/null

    # Prompt for sudo upfront
    sudo -v

    # Create "install" directory for manual downloads
    mkdir -p "$HOME/install"

    # System setup (always runs - these are idempotent)
    echo ""
    tput setaf 5
    echo "--- System Configuration ---"
    tput sgr0
    source "$SETUP_DIR/system/macos.sh"
    source "$SETUP_DIR/system/homebrew.sh"

    # App setup (tracked) - uses centralized ALL_APPS list
    echo ""
    tput setaf 5
    echo "--- App Configuration ---"
    tput sgr0
    run_all_apps

    # Final message
    echo ""
    osascript -e 'display dialog "Setup complete! Remember to setup Dropbox and Alfred."' 2>/dev/null

    # Show final status
    show_all_status

    # Ask about reboot
    echo ""
    read -p "Would you like to reboot now? [y/N]: " reboot_choice
    if [[ "$reboot_choice" =~ ^[Yy]$ ]]; then
        countdown 10 "Rebooting in"
        reboot
    fi
}

# Run update (idempotent steps only)
run_update() {
    echo ""
    tput setaf 6
    echo "=== Update (idempotent steps only) ==="
    tput sgr0
    echo ""

    osascript -e 'tell application "System Preferences" to quit' 2>/dev/null
    sudo -v

    source "$SETUP_DIR/system/macos.sh"
    source "$SETUP_DIR/system/homebrew.sh"

    echo ""
    tput setaf 2
    echo "Update complete!"
    tput sgr0
}

# Change machine type
change_machine_type() {
    local current=$(get_machine_type)
    echo ""
    echo "Current machine type: ${current:-not set}"
    prompt_machine_type
}

# Reset and run all
reset_all() {
    echo ""
    tput setaf 1
    echo "WARNING: This will reset all setup progress!"
    tput sgr0
    read -p "Are you sure? [y/N]: " confirm

    if [[ "$confirm" =~ ^[Yy]$ ]]; then
        # Keep machine type but clear app tracking
        local machine_type=$(get_machine_type)
        rm -f "$SETUP_LOG"
        if [ -n "$machine_type" ]; then
            set_machine_type "$machine_type"
        fi
        run_full_setup
    else
        echo "Cancelled"
    fi
}

# Main dispatch
case "$MODE" in
    --full)
        run_full_setup
        ;;
    --update)
        run_update
        ;;
    --select)
        select_app
        ;;
    --status)
        show_all_status
        ;;
    --change-machine)
        change_machine_type
        ;;
    --reset)
        reset_all
        ;;
    *)
        echo "Usage: main.sh [--full|--update|--select|--status|--change-machine|--reset]"
        exit 1
        ;;
esac
