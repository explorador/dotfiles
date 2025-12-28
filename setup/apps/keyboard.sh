#!/bin/bash

# macOS Keyboard Shortcuts configuration
# Disables unwanted system services

# Disable "Search man Page Index in Terminal" service
# Create temporary settings file
TEMP_SETTINGS_FILE=$(mktemp -t 'man-shortcuts-off.json') && cat > $TEMP_SETTINGS_FILE <<EOF
{
  "NSServicesStatus": {
    "com.apple.Terminal - Search man Page Index in Terminal - searchManPages": {
      "presentation_modes": {
        "ContextMenu": false,
        "ServicesMenu": false
      },
      "enabled_context_menu": false,
      "enabled_services_menu": false
    }
  }
}
EOF

# Convert to XML and apply settings
plutil -convert xml1 -o - ${TEMP_SETTINGS_FILE} | defaults import pbs -
rm ${TEMP_SETTINGS_FILE}
/System/Library/CoreServices/pbs -flush
killall pbs 2>/dev/null
