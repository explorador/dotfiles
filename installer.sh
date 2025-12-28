#!/bin/bash

DOTFILES="$HOME/.dotfiles"
SETUP_DIR="$DOTFILES/setup"

# Source helper functions
source "$SETUP_DIR/lib/tracking.sh"

# Clear screen and show header
tput clear
tput setaf 7
cat << "EOF"
   __
   \ \_____         *
###[==_____>   *
   /_/      __
            \ \_____
         ###[==_____>
    *      /_/

Dotfiles Installation Wizard
EOF
tput sgr0

# Check if this is first run (no setup log exists)
if [ ! -f "$SETUP_LOG" ] || [ -z "$(get_machine_type)" ]; then
    echo ""
    tput setaf 6
    echo "First time setup detected!"
    tput sgr0
    prompt_machine_type
    echo ""
fi

# Show current machine type
machine_type=$(get_machine_type)
echo ""
echo "Machine type: $machine_type"
echo ""

# Menu
tput cup 14 15
tput rev
echo " SELECT OPTION "
tput sgr0

tput cup 16 2
echo "1. Full Setup (first-time install)"

tput cup 17 2
echo "2. Update (idempotent steps only)"

tput cup 18 2
echo "3. Configure specific app"

tput cup 19 2
echo "4. Reset and re-run all"

tput cup 20 2
echo "5. Show status"

tput cup 21 2
echo "6. Change machine type"

tput cup 23 2
tput bold
read -p "Enter your choice [1-6]: " choice
tput sgr0

# Run selected option
case $choice in
    1)
        source "$SETUP_DIR/main.sh" --full
        ;;
    2)
        source "$SETUP_DIR/main.sh" --update
        ;;
    3)
        source "$SETUP_DIR/main.sh" --select
        ;;
    4)
        source "$SETUP_DIR/main.sh" --reset
        ;;
    5)
        source "$SETUP_DIR/main.sh" --status
        ;;
    6)
        source "$SETUP_DIR/main.sh" --change-machine
        ;;
    *)
        echo "Invalid choice"
        exit 1
        ;;
esac
