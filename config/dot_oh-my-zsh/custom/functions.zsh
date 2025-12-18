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
