#!/bin/bash

# macOS System Settings
# Idempotent - safe to run multiple times

tput setaf 7
tput smso; echo " Running macOS config "; tput rmso
tput sgr0

# Close any open System Preferences panes to prevent them from
# overriding settings we're about to change
osascript -e 'tell application "System Preferences" to quit' 2>/dev/null

# Ask for the administrator password upfront
sudo -v


# Dock
# ----------------------------------------------------------------
# Uncheck "Show recent applications in Dock"
defaults write com.apple.dock "show-recents" -bool false


# Siri
# ----------------------------------------------------------------
# Disable "Ask Siri"
defaults write com.apple.assistant.support "Assistant Enabled" -bool false


# Keyboard
# ----------------------------------------------------------------
# Keyboard > Keyboard > Use F1, F1, etc. keys as standard function keys
defaults write -g com.apple.keyboard.fnState -bool true

# Disable default shortcode for screenshots
# Keyboard > Shortcuts > Disable "Save picture of selected area as a file" shortcut
defaults write com.apple.symbolichotkeys.plist AppleSymbolicHotKeys -dict-add 30 "
  <dict>
    <key>enabled</key><false/>
    <key>value</key><dict>
      <key>type</key><string>standard</string>
      <key>parameters</key>
      <array>
        <integer>52</integer>
        <integer>21</integer>
        <integer>1179648</integer>
      </array>
    </dict>
  </dict>
"


# Mouse
# ----------------------------------------------------------------
# Mouse > Point & Click > Secondary click
# Options: "TwoButton", "OneButton", "TwoButtonSwapped"
defaults write com.apple.AppleMultitouchMouse MouseButtonMode -string "TwoButton"
# Mouse speed to "Fast"
defaults write -g com.apple.mouse.scaling 3


# Trackpad
# ----------------------------------------------------------------
# Secondary click (click in bottom right corner)
defaults write com.apple.AppleMultitouchTrackpad TrackpadCornerSecondaryClick -int 2
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadCornerSecondaryClick -int 2
defaults write com.apple.AppleMultitouchTrackpad TrackpadRightClick -bool false
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadRightClick -bool false
# Tracking speed
defaults write NSGlobalDomain com.apple.trackpad.scaling -float 1.5


# Date and Time
# ----------------------------------------------------------------
# Time zone is set automatically via Location Services (macOS default).
# Use a 24-hour clock and display date.
defaults write com.apple.menuextra.clock DateFormat -string "EEE MMM d HH:mm"
defaults write com.apple.menuextra.clock ShowAMPM -bool false


# Menu bar
# ----------------------------------------------------------------
# Remove siri icon in menu bar
defaults write com.apple.Siri StatusMenuVisible 0
# Disable "Show percentage"
defaults write com.apple.menuextra.battery ShowPercent -string "NO"
# Uncheck "Show input menu in menu bar" (Hide language bar)
defaults write com.apple.TextInputMenu visible -bool false


# Finder & General
# ----------------------------------------------------------------
# Show hidden files
defaults write com.apple.finder AppleShowAllFiles -bool true
# Show filename extensions
defaults write NSGlobalDomain AppleShowAllExtensions -bool true
# Use column list view in all Finder windows by default
# Four-letter codes for the other view modes: `icnv`, `clmv`, `glyv`
defaults write com.apple.finder FXPreferredViewStyle -string "clmv"
# Avoid creating .DS_Store files on network or USB volumes
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true
# Show scrollbars when scrolling
# Possible values: `WhenScrolling`, `Automatic` and `Always`
defaults write NSGlobalDomain AppleShowScrollBars -string "WhenScrolling"
# When performing a search, search the current folder by default
defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"
# Save to disk (not to iCloud) by default
defaults write NSGlobalDomain NSDocumentSaveNewDocumentsToCloud -bool false
# Disable "natural" (Lion-style) scrolling
defaults write NSGlobalDomain com.apple.swipescrolldirection -bool false
# Reveal IP address, hostname, OS version, etc. when clicking the clock in the login window
sudo defaults write /Library/Preferences/com.apple.loginwindow AdminHostInfo HostName
# Disable Gatekeeper
sudo spctl --master-disable


# Dock icons
# ----------------------------------------------------------------
__dock_item() {
    printf '%s%s%s%s%s' \
           '<dict><key>tile-data</key><dict><key>file-data</key><dict>' \
           '<key>_CFURLString</key><string>' \
           "$1" \
           '</string><key>_CFURLStringType</key><integer>0</integer>' \
           '</dict></dict></dict>'
}

if [ "$(get_machine_type)" = "work" ]; then
    # Work Dock: excludes Spotify, WhatsApp, Messages, Teams
    defaults write com.apple.dock \
        persistent-apps -array \
        "$(__dock_item /System/Applications/App\ Store.app)" \
        "$(__dock_item /System/Applications/Launchpad.app)" \
        '{"tile-type"="spacer-tile";}' \
        "$(__dock_item /Applications/Safari.app)" \
        "$(__dock_item /Applications/Firefox\ Developer\ Edition.app)" \
        '{"tile-type"="spacer-tile";}' \
        "$(__dock_item /Applications/kitty.app)" \
        "$(__dock_item /Applications/Figma.app)" \
        "$(__dock_item /Applications/Postman.app)" \
        "$(__dock_item /Applications/SnippetsLab.app)" \
        "$(__dock_item /Applications/Dash.app)" \
        '{"tile-type"="spacer-tile";}' \
        "$(__dock_item /Applications/Slack.app)" \
        "$(__dock_item /System/Applications/Mail.app)" \
        "$(__dock_item /Applications/1Password.app)"
else
    # Personal Dock: includes all apps
    defaults write com.apple.dock \
        persistent-apps -array \
        "$(__dock_item /System/Applications/App\ Store.app)" \
        "$(__dock_item /System/Applications/Launchpad.app)" \
        '{"tile-type"="spacer-tile";}' \
        "$(__dock_item /Applications/Safari.app)" \
        "$(__dock_item /Applications/Firefox\ Developer\ Edition.app)" \
        '{"tile-type"="spacer-tile";}' \
        "$(__dock_item /Applications/kitty.app)" \
        "$(__dock_item /Applications/Figma.app)" \
        "$(__dock_item /Applications/Postman.app)" \
        "$(__dock_item /Applications/SnippetsLab.app)" \
        "$(__dock_item /Applications/Dash.app)" \
        '{"tile-type"="spacer-tile";}' \
        "$(__dock_item /Applications/Slack.app)" \
        "$(__dock_item /Applications/Microsoft\ Teams.app)" \
        "$(__dock_item /System/Applications/Messages.app)" \
        "$(__dock_item /Applications/WhatsApp.app)" \
        "$(__dock_item /System/Applications/Mail.app)" \
        "$(__dock_item /Applications/1Password.app)" \
        "$(__dock_item /Applications/Spotify.app)"
fi

# Downloads folder next to Trash (both work and personal)
defaults write com.apple.dock persistent-others -array "<dict>
    <key>tile-data</key>
    <dict>
        <key>arrangement</key>
        <integer>1</integer>
        <key>displayas</key>
        <integer>0</integer>
        <key>file-data</key>
        <dict>
            <key>_CFURLString</key>
            <string>file://$HOME/Downloads</string>
            <key>_CFURLStringType</key>
            <integer>15</integer>
        </dict>
        <key>file-type</key>
        <integer>2</integer>
        <key>showas</key>
        <integer>0</integer>
    </dict>
    <key>tile-type</key>
    <string>directory-tile</string>
</dict>"


# Kill affected processes to apply changes
killall Dock 2>/dev/null
killall SystemUIServer 2>/dev/null
killall Finder 2>/dev/null

echo "macOS configuration complete!"
