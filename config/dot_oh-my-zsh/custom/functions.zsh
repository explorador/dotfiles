# ===========================================
# Custom Functions
# ===========================================

# List all custom functions
myfunctions() {
	echo "Available custom functions:"
	echo "  wp-permissions  - Fix WordPress file permissions"
	echo "  search          - Search for files by name"
	echo "  cleardns        - Clear macOS DNS cache"
	echo "  watchdefaults   - Watch for macOS defaults changes"
	echo "  brewsync        - Sync Homebrew packages (prompts for personal/work config)"
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
# Only installs packages listed in the Brewfile, does not export or remove anything
# Usage: brewsync [--pull]
#   --pull  Pull latest dotfiles before syncing
brewsync() {
	local DOTFILES_DIR="$HOME/.dotfiles"
	local BREWFILE="$DOTFILES_DIR/Brewfile"

	if [[ ! -f "$BREWFILE" ]]; then
		echo "Error: Brewfile not found at $BREWFILE"
		return 1
	fi

	# Pull latest dotfiles if --pull flag is passed
	if [[ "$1" == "--pull" ]]; then
		echo "Pulling latest dotfiles..."
		git -C "$DOTFILES_DIR" pull
		shift
	fi

	# Prompt for configuration
	echo "Select configuration:"
	echo "  1) Personal (all packages)"
	echo "  2) Work (excludes personal apps)"
	echo ""
	read "choice?Enter choice [1]: "

	case "${choice:-1}" in
		1|personal)
			echo "\nInstalling all packages..."
			brew bundle --file="$BREWFILE"
			;;
		2|work)
			echo "\nInstalling work packages only..."
			MACHINE=work brew bundle --file="$BREWFILE"
			;;
		*)
			echo "Invalid choice"
			return 1
			;;
	esac

	echo "\nHomebrew sync complete!"
}
