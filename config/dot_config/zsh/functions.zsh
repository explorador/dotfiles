# ===========================================
# Custom Functions
# ===========================================

# List all custom functions
myfunctions() {
	echo "Available custom functions:"
	echo "  dotfiles        - Run dotfiles setup wizard"
	echo "  brewsync        - Sync Homebrew packages from Brewfile"
	echo "  wp-permissions  - Fix WordPress file permissions"
	echo "  search          - Search for files by name"
	echo "  cleardns        - Clear macOS DNS cache"
	echo "  watchdefaults   - Watch for macOS defaults changes"
}

# ===========================================
# Dotfiles
# ===========================================

# Run dotfiles setup wizard
dotfiles() {
	~/.dotfiles/installer.sh
}

# ===========================================
# WordPress
# ===========================================

# Fix WordPress Permissions
# (based on recommendations from http://codex.wordpress.org/Hardening_WordPress#File_permissions)
wp-permissions() {
	find ./ -type d -exec chmod 755 {} \;
	find ./ -type f -exec chmod 644 {} \;
	chmod 600 wp-config.php
}

# ===========================================
# System Utilities
# ===========================================

# Search file by name
search() {
	find ~/ -iname "$1" 2> /dev/null
}

# Clear DNS cache
cleardns() {
	sudo dscacheutil -flushcache; sudo killall -HUP mDNSResponder; echo "macOS DNS Cache Reset"
}

# Watch for "defaults" macos settings changes
watchdefaults() {
	_saveOriginalSettings() {
		defaults read > macosdefaults.txt
	}

	while true
	do
		if [ ! -e macosdefaults.txt ]
			then
			_saveOriginalSettings
		fi

		# Save "changes" file
		defaults read > macosdefaults2.txt
		# Get changes
		diff -uw macosdefaults.txt macosdefaults2.txt | grep -E "^\+" && _saveOriginalSettings
		sleep 1
	done
}

# ===========================================
# Homebrew
# ===========================================

# Sync Homebrew packages from dotfiles Brewfile
# Uses saved machine type from setup, or prompts if not configured
# Usage: brewsync [--pull]
#   --pull  Pull latest dotfiles before syncing
brewsync() {
	local DOTFILES_DIR="$HOME/.dotfiles"
	local BREWFILE="$DOTFILES_DIR/Brewfile"
	local SETUP_LOG="$DOTFILES_DIR/.setup-log"

	[[ ! -f "$BREWFILE" ]] && echo "Error: Brewfile not found" && return 1

	# Pull if requested
	[[ "$1" == "--pull" ]] && echo "Pulling latest dotfiles..." && git -C "$DOTFILES_DIR" pull && shift

	# Check if machine type already configured
	local machine_type
	if [[ -f "$SETUP_LOG" ]]; then
		machine_type=$(grep "^MACHINE=" "$SETUP_LOG" 2>/dev/null | cut -d= -f2)
	fi

	if [[ -n "$machine_type" ]]; then
		echo "Using saved machine type: $machine_type"
		[[ "$machine_type" == "work" ]] && export HOMEBREW_MACHINE=work
	else
		# Prompt only if not configured
		echo "Select configuration:"
		echo "  1) Personal (all packages)"
		echo "  2) Work (excludes personal apps)"
		read "choice?Enter choice [1]: "
		[[ "${choice:-1}" == "2" ]] && export HOMEBREW_MACHINE=work
	fi

	brew bundle --file="$BREWFILE"
	echo "\nHomebrew sync complete!"
}
