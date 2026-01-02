#!/bin/bash

# Main orchestrator script for dotfiles setup

# Source helper functions (chain: tracking -> common -> gum)
source "$HOME/.dotfiles/setup/lib/tracking.sh"

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
    while true; do
        gum_header "Select App to Configure"

        # Build options array with status indicators
        local options=()
        for app in "${ALL_APPS[@]}"; do
            if is_configured "$app"; then
                options+=("$app (configured)")
            else
                options+=("$app")
            fi
        done
        options+=("Reconfigure ALL apps")
        options+=("← Back to main menu")

        # Use gum to select
        local selection=$(gum_choose "${options[@]}")

        case "$selection" in
            "← Back to main menu")
                return 0
                ;;
            "Reconfigure ALL apps")
                for app in "${ALL_APPS[@]}"; do
                    run_forced "$app" "$SETUP_DIR/apps/${app}.sh"
                done
                ;;
            *)
                # Extract app name (remove " (configured)" suffix if present)
                local selected_app="${selection% (configured)}"
                run_forced "$selected_app" "$SETUP_DIR/apps/${selected_app}.sh"
                ;;
        esac
    done
}

# Run full setup
run_full_setup() {
    gum_header "Full Setup"

    # Close System Preferences
    osascript -e 'tell application "System Preferences" to quit' 2>/dev/null

    # Prompt for sudo upfront
    sudo -v

    # Create "install" directory for manual downloads
    mkdir -p "$HOME/install"

    # System setup (always runs - these are idempotent)
    gum_subheader "System Configuration"
    source "$SETUP_DIR/system/macos.sh"
    source "$SETUP_DIR/system/homebrew.sh"
    source "$SETUP_DIR/system/node.sh"

    # App setup (tracked) - uses centralized ALL_APPS list
    gum_subheader "App Configuration"
    run_all_apps

    # Final message
    echo ""
    gum_status "success" "Setup complete! Remember to setup Dropbox and Alfred."

    # Show final status
    show_all_status

    # Ask about reboot
    echo ""
    if gum_confirm "Would you like to reboot now?"; then
        countdown 10 "Rebooting in"
        reboot
    fi
}

# Run update (idempotent steps only)
run_update() {
    gum_header "Update (idempotent steps only)"

    osascript -e 'tell application "System Preferences" to quit' 2>/dev/null
    sudo -v

    source "$SETUP_DIR/system/macos.sh"
    source "$SETUP_DIR/system/homebrew.sh"

    echo ""
    gum_status "success" "Update complete!"
}

# Change machine type
change_machine_type() {
    local current=$(get_machine_type)
    echo ""
    gum_status "info" "Current machine type: ${current:-not set}"
    prompt_machine_type
}

# Reset and run all
reset_all() {
    echo ""
    gum_status "warning" "This will reset all setup progress!"

    if gum_confirm "Are you sure?"; then
        # Keep machine type but clear app tracking
        local machine_type=$(get_machine_type)
        rm -f "$SETUP_LOG"
        if [ -n "$machine_type" ]; then
            set_machine_type "$machine_type"
        fi
        run_full_setup
    else
        gum_status "info" "Cancelled"
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
