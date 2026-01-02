#!/bin/bash

# Source helper functions (chain: tracking -> common -> gum)
source "$HOME/.dotfiles/setup/lib/tracking.sh"

LOGO='   __
   \ \_____         *
###[==_____>   *
   /_/      __
            \ \_____
         ###[==_____>
    *      /_/
'

# Main menu loop
main_menu() {
    while true; do
        # Clear screen and show header
        clear

        gum_banner "$LOGO"
        gum_header "Dotfiles Installation Wizard"

        # Check if this is first run (no setup log exists)
        if [ ! -f "$SETUP_LOG" ] || [ -z "$(get_machine_type)" ]; then
            echo ""
            gum_status "info" "First time setup detected!"
            prompt_machine_type
            echo ""
        fi

        # Show current machine type
        machine_type=$(get_machine_type)
        echo ""
        gum_status "info" "Machine type: $machine_type"
        echo ""

        # Menu options
        OPTIONS=(
            "Full Setup (first-time install)"
            "Update (idempotent steps only)"
            "Configure specific app"
            "Reset and re-run all"
            "Show status"
            "Change machine type"
            "Exit"
        )

        echo ""
        choice=$(gum_choose "${OPTIONS[@]}")

        # Run selected option
        case "$choice" in
            "Full Setup (first-time install)")
                source "$SETUP_DIR/main.sh" --full
                wait_for_keypress
                ;;
            "Update (idempotent steps only)")
                source "$SETUP_DIR/main.sh" --update
                wait_for_keypress
                ;;
            "Configure specific app")
                # This has its own submenu with back option
                source "$SETUP_DIR/main.sh" --select
                ;;
            "Reset and re-run all")
                source "$SETUP_DIR/main.sh" --reset
                wait_for_keypress
                ;;
            "Show status")
                source "$SETUP_DIR/main.sh" --status
                wait_for_keypress
                ;;
            "Change machine type")
                source "$SETUP_DIR/main.sh" --change-machine
                wait_for_keypress
                ;;
            "Exit")
                echo ""
                gum_status "success" "Goodbye!"
                exit 0
                ;;
            *)
                gum_status "error" "Invalid choice"
                sleep 1
                ;;
        esac
    done
}

# Run main menu
main_menu
