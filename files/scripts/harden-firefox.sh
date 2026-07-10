#!/bin/bash
set -euo pipefail

# 1. Download arkenfox user.js
echo "Downloading arkenfox user.js..."
curl -L https://raw.githubusercontent.com/arkenfox/user.js/master/user.js -o /tmp/user.js

# 2. Create policies.json content
echo "Creating policies.json..."
cat <<'EOF' > /tmp/policies.json
{
  "policies": {
    "DisableTelemetry": true,
    "DisableFirefoxStudies": true,
    "DisablePocket": true,
    "DisableSetDesktopBackground": true,
    "DontCheckDefaultBrowser": true,
    "DisableProfileRefresh": true,
    "OverrideFirstRunPage": "",
    "OverridePostUpdatePage": "",
    "AppAutoUpdate": false,
    "BackgroundAppUpdate": false,
    "DisableAppUpdate": true,
    "EnableTrackingProtection": {
      "Value": true,
      "Locked": false,
      "Cryptomining": true,
      "Fingerprinting": true
    },
    "ExtensionSettings": {
      "uBlock0@raymondhill.net": {
        "installation_mode": "normal_installed",
        "install_url": "https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/latest.xpi"
      }
    }
  }
}
EOF

# 3. Determine Firefox Installation Path
FIREFOX_PATH="/usr/lib64/firefox"
if [ ! -d "$FIREFOX_PATH" ]; then
    FIREFOX_PATH="/usr/lib/firefox"
fi

if [ ! -d "$FIREFOX_PATH" ]; then
    echo "Error: Firefox installation directory not found."
    exit 1
fi

echo "Detected Firefox path: $FIREFOX_PATH"

# 4. Deploy user.js to defaults/pref
echo "Deploying user.js..."
mkdir -p "$FIREFOX_PATH/defaults/pref"
mv /tmp/user.js "$FIREFOX_PATH/defaults/pref/user.js"

# 5. Deploy policies.json to distribution
echo "Deploying policies.json..."
mkdir -p "$FIREFOX_PATH/distribution"
mv /tmp/policies.json "$FIREFOX_PATH/distribution/policies.json"

echo "Firefox hardening complete."
