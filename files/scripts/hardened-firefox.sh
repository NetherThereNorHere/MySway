#!/usr/bin/env bash
set -euo pipefail

# --- CONFIGURATION: PINNED VERSIONS & CHECKSUMS ---
ARKENFOX_VERSION="v144.0"

EXPECTED_USERJS_SHA="d5558cd419c8d46bdc958064cb97f963d1ea793866414c025906ec15033512ed"

# --------------------------------------------------

echo "=== Hardening Firefox with Arkenfox ${ARKENFOX_VERSION} ==="

echo "Downloading arkenfox user.js..."
curl -L -o /tmp/user.js "https://raw.githubusercontent.com/arkenfox/user.js/${ARKENFOX_VERSION}/user.js"

# Verify Checksum
echo "${EXPECTED_USERJS_SHA}  /tmp/user.js" | sha256sum -c -
if [ $? -ne 0 ]; then
    echo "ERROR: arkenfox user.js checksum verification failed!"
    exit 1
fi

# 2. Create and Validate policies.json
echo "Creating and validating policies.json..."
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

# Validate JSON syntax before deploying (Requires 'jq')
if ! jq empty /tmp/policies.json; then
    echo "ERROR: policies.json is not valid JSON!"
    exit 1
fi

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

# Record versions for update checker (Optional, similar to Yazi script)
echo "${ARKENFOX_VERSION}" > /etc/arkenfox-version

echo "Firefox hardening complete and verified."
