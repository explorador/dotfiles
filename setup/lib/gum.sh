#!/bin/bash

# Gum TUI library for dotfiles setup
# Bootstraps gum binary and provides wrapper functions

# Guard against multiple sourcing
[[ -n "$_GUM_SH_LOADED" ]] && return 0
_GUM_SH_LOADED=1

# Gum version to download
GUM_VERSION="0.14.5"

# Local bin directory for gum binary
GUM_BIN_DIR="$HOME/.local/bin"
GUM_BIN="$GUM_BIN_DIR/gum"

#=============================================================================
# AYU MIRAGE COLOR PALETTE
#=============================================================================
readonly AYU_BG="#1f2430"
readonly AYU_FG="#cbccc6"
readonly AYU_GREEN="#bae67e"
readonly AYU_YELLOW="#ffcc66"
readonly AYU_BLUE="#73d0ff"
readonly AYU_LAVENDER="#d4bfff"
readonly AYU_TEAL="#95e6cb"
readonly AYU_ORANGE="#ffad66"
readonly AYU_RED="#f28779"
readonly AYU_GRAY="#707a8c"

#=============================================================================
# GUM BOOTSTRAP
#=============================================================================

# Download and install gum binary if not available
ensure_gum() {
    # Check if gum is already in PATH
    if command -v gum &> /dev/null; then
        return 0
    fi

    # Check if we already downloaded it
    if [[ -x "$GUM_BIN" ]]; then
        export PATH="$GUM_BIN_DIR:$PATH"
        return 0
    fi

    echo "Downloading gum for TUI support..."

    # Detect architecture
    local arch
    case "$(uname -m)" in
        arm64|aarch64) arch="arm64" ;;
        x86_64|amd64)  arch="amd64" ;;
        *)
            echo "Unsupported architecture: $(uname -m)"
            return 1
            ;;
    esac

    # Detect OS
    local os
    case "$(uname -s)" in
        Darwin) os="Darwin" ;;
        Linux)  os="Linux" ;;
        *)
            echo "Unsupported OS: $(uname -s)"
            return 1
            ;;
    esac

    # Create bin directory
    mkdir -p "$GUM_BIN_DIR"

    # Download and extract
    local url="https://github.com/charmbracelet/gum/releases/download/v${GUM_VERSION}/gum_${GUM_VERSION}_${os}_${arch}.tar.gz"
    local temp_dir=$(mktemp -d)

    if curl -fsSL "$url" | tar -xz -C "$temp_dir" 2>/dev/null; then
        # Find the gum binary (it's nested in a versioned directory)
        local gum_binary=$(find "$temp_dir" -name "gum" -type f -perm +111 2>/dev/null | head -1)
        if [[ -n "$gum_binary" ]]; then
            mv "$gum_binary" "$GUM_BIN"
            chmod +x "$GUM_BIN"
            rm -rf "$temp_dir"
            export PATH="$GUM_BIN_DIR:$PATH"
            echo "gum installed successfully"
            return 0
        fi
    fi

    rm -rf "$temp_dir"
    echo "Failed to download gum, falling back to basic prompts"
    return 1
}

# Auto-bootstrap when sourced (runs once)
if [[ -z "$_GUM_BOOTSTRAPPED" ]]; then
    _GUM_BOOTSTRAPPED=1
    ensure_gum
fi

# Check if gum is available
has_gum() {
    command -v gum &> /dev/null
}

#=============================================================================
# GUM WRAPPER FUNCTIONS
#=============================================================================

# Display styled header
# Usage: gum_header "Title"
gum_header() {
    local title="$1"
    if has_gum; then
        gum style --foreground="$AYU_YELLOW" --bold --border=double --padding="0 2" "$title"
    else
        echo ""
        echo "=== $title ==="
        echo ""
    fi
}

# Display styled subheader
# Usage: gum_subheader "Subtitle"
gum_subheader() {
    local title="$1"
    if has_gum; then
        gum style --foreground="$AYU_LAVENDER" --bold -- "― $title ―"
    else
        echo ""
        echo "--- $title ---"
    fi
}

# Display a menu and return the selected option
# Usage: choice=$(gum_choose "Option 1" "Option 2" "Option 3")
gum_choose() {
    if has_gum; then
        gum choose --cursor.foreground "$AYU_YELLOW" --selected.foreground "$AYU_YELLOW" "$@"
    else
        # Fallback: numbered menu (print to stderr so it's visible in subshell)
        local i=1
        for opt in "$@"; do
            echo "$i. $opt" >&2
            ((i++))
        done
        echo -n "Enter choice: " >&2
        read choice </dev/tty
        local idx=1
        for opt in "$@"; do
            if [[ "$choice" == "$idx" ]]; then
                echo "$opt"
                return
            fi
            ((idx++))
        done
        echo "$1"  # Default to first option
    fi
}

# Ask for confirmation
# Usage: gum_confirm "Are you sure?" && echo "Yes"
gum_confirm() {
    local prompt="${1:-Continue?}"
    if has_gum; then
        gum confirm --prompt.foreground "$AYU_YELLOW" --selected.background "$AYU_YELLOW" --selected.foreground "$AYU_BG" "$prompt"
    else
        read -p "$prompt [y/N]: " response
        [[ "$response" =~ ^[Yy]$ ]]
    fi
}

# Display a spinner while running a command
# Usage: gum_spin "Installing..." brew install something
gum_spin() {
    local title="$1"
    shift
    if has_gum; then
        gum spin --spinner dot --spinner.foreground "$AYU_BLUE" --title "$title" --title.foreground "$AYU_FG" -- "$@"
    else
        echo "$title"
        "$@"
    fi
}

# Prompt for text input
# Usage: value=$(gum_input "Enter value" "placeholder")
# NOTE: Not currently used. Available for future interactive prompts.
gum_input() {
    local prompt="$1"
    local placeholder="${2:-}"
    if has_gum; then
        gum input --placeholder "$placeholder" --prompt "$prompt: " --prompt.foreground "$AYU_YELLOW" --cursor.foreground "$AYU_YELLOW"
    else
        read -p "$prompt: " value
        echo "$value"
    fi
}

# Display formatted status message
# Usage: gum_status "success" "Task completed"
# Types: success, error, warning, info
gum_status() {
    local type="$1"
    local message="$2"
    if has_gum; then
        case "$type" in
            success) gum style --foreground="$AYU_GREEN" "✓ $message" ;;
            error)   gum style --foreground="$AYU_RED" "✗ $message" ;;
            warning) gum style --foreground="$AYU_ORANGE" "! $message" ;;
            info)    gum style --foreground="$AYU_BLUE" "→ $message" ;;
        esac
    else
        case "$type" in
            success) echo "✓ $message" ;;
            error)   echo "✗ $message" ;;
            warning) echo "! $message" ;;
            info)    echo "→ $message" ;;
        esac
    fi
}

# Display a banner/logo
# Usage: gum_banner "text"
gum_banner() {
    local text="$1"
    if has_gum; then
        gum style --foreground="$AYU_TEAL" --bold "$text"
    else
        echo "$text"
    fi
}

# Format text (for inline styled output)
# Usage: gum_format --bold "text"
# NOTE: Not currently used. Available for future markdown/text formatting.
gum_format() {
    if has_gum; then
        gum format "$@"
    else
        # Just echo the last argument (the text)
        echo "${@: -1}"
    fi
}

# Wait for user keypress to continue
# Usage: wait_for_keypress
wait_for_keypress() {
    echo ""
    gum_status "info" "Press any key to return to menu..."
    read -n 1 -s
}
