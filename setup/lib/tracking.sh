#!/bin/bash

# State tracking library for dotfiles setup
# Tracks which apps have been configured to avoid re-running setup

# Source common utilities (common.sh -> gum.sh provides TUI functions)
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/common.sh"

SETUP_LOG="$DOTFILES_ROOT/.setup-log"

# Build list of all trackable apps from apps/ directory
ALL_APPS=()
for _script in "$SETUP_DIR/apps/"*.sh; do
    ALL_APPS+=("$(basename "$_script" .sh)")
done
unset _script _app

# Initialize the setup log if it doesn't exist
init_setup_log() {
    if [ ! -f "$SETUP_LOG" ]; then
        cat > "$SETUP_LOG" << 'EOF'
# Dotfiles Setup Log
# Format: KEY=value
# Machine type and per-app timestamps
EOF
    fi
}

# Get the machine type (work/personal)
get_machine_type() {
    if [ -f "$SETUP_LOG" ]; then
        grep "^MACHINE=" "$SETUP_LOG" 2>/dev/null | cut -d= -f2
    fi
}

# Set the machine type
set_machine_type() {
    local machine_type="$1"
    init_setup_log

    # Remove existing MACHINE line if present
    if grep -q "^MACHINE=" "$SETUP_LOG" 2>/dev/null; then
        sed -i '' '/^MACHINE=/d' "$SETUP_LOG"
    fi

    # Add MACHINE as first data line (after comments)
    local temp_file=$(mktemp)
    awk -v machine="MACHINE=$machine_type" '
        /^#/ { print; next }
        !inserted { print machine; inserted=1 }
        { print }
        END { if (!inserted) print machine }
    ' "$SETUP_LOG" > "$temp_file"
    mv "$temp_file" "$SETUP_LOG"
}

# Prompt user for machine type
prompt_machine_type() {
    echo ""
    gum_status "info" "Is this a Work or Personal machine?"
    echo ""

    local choice
    choice=$(gum_choose \
        "Personal (installs all apps including Spotify, Dropbox, etc.)" \
        "Work (skips personal apps)")

    case "$choice" in
        Personal*)
            set_machine_type "personal"
            gum_status "success" "Machine type set to: personal"
            ;;
        Work*)
            set_machine_type "work"
            gum_status "success" "Machine type set to: work"
            ;;
        *)
            gum_status "warning" "Invalid choice, defaulting to personal"
            set_machine_type "personal"
            ;;
    esac
}

# Check if an app has been configured
is_configured() {
    local app_name="$1"
    grep -q "^${app_name}=" "$SETUP_LOG" 2>/dev/null
}

# Mark an app as configured with current timestamp
mark_configured() {
    local app_name="$1"
    local timestamp=$(date -u +"%Y-%m-%dT%H:%M:%S")

    init_setup_log

    # Remove existing entry if present
    if grep -q "^${app_name}=" "$SETUP_LOG" 2>/dev/null; then
        sed -i '' "/^${app_name}=/d" "$SETUP_LOG"
    fi

    # Add new entry
    echo "${app_name}=${timestamp}" >> "$SETUP_LOG"
}

# Remove app from configured list (for re-running)
unmark_configured() {
    local app_name="$1"
    if [ -f "$SETUP_LOG" ]; then
        sed -i '' "/^${app_name}=/d" "$SETUP_LOG"
    fi
}

# Get list of all configured apps
list_configured() {
    if [ -f "$SETUP_LOG" ]; then
        grep -v "^#" "$SETUP_LOG" | grep -v "^$" | grep -v "^MACHINE=" | cut -d= -f1
    fi
}

# Print status for an app
print_status() {
    local app_name="$1"
    local status="$2"  # "running", "skipped", "done", "failed"

    case "$status" in
        running)
            color_yellow
            echo ">>> Configuring: $app_name"
            color_reset
            ;;
        skipped)
            color_gray
            echo "--- Skipping: $app_name (already configured)"
            color_reset
            ;;
        done)
            color_green
            echo "<<< Done: $app_name"
            color_reset
            ;;
        failed)
            color_red
            echo "!!! Failed: $app_name"
            color_reset
            ;;
    esac
}

# Run app setup if not already configured
# Usage: run_if_needed "app_name" "path/to/script.sh"
run_if_needed() {
    local app_name="$1"
    local script_path="$2"

    if is_configured "$app_name"; then
        print_status "$app_name" "skipped"
        return 0
    fi

    print_status "$app_name" "running"
    if source "$script_path"; then
        mark_configured "$app_name"
        print_status "$app_name" "done"
        return 0
    else
        print_status "$app_name" "failed"
        return 1
    fi
}

# Force re-run an app setup (removes from log first)
run_forced() {
    local app_name="$1"
    local script_path="$2"

    unmark_configured "$app_name"
    run_if_needed "$app_name" "$script_path"
}

# Display setup status for all apps
show_all_status() {
    gum_header "Setup Status"

    local machine_type=$(get_machine_type)
    if [ -n "$machine_type" ]; then
        echo "Machine type: $machine_type"
        echo ""
    fi

    for app in "${ALL_APPS[@]}"; do
        if is_configured "$app"; then
            color_green
            printf "[x] %s\n" "$app"
        else
            color_gray
            printf "[ ] %s\n" "$app"
        fi
    done
    color_reset
    echo ""
}

# Run all app setups (uses ALL_APPS list)
run_all_apps() {
    for app in "${ALL_APPS[@]}"; do
        run_if_needed "$app" "$SETUP_DIR/apps/${app}.sh"
    done
}
