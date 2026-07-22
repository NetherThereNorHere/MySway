#!/usr/bin/env bash
set -euo pipefail

# --- CONFIGURATION: PINNED VERSIONS & CHECKSUMS ---
# Arkenfox user.js v126.0 (Example: Replace with latest stable tag)
ARKENFOX_VERSION="v144.0"
# You MUST get the actual SHA256 for the user.js file from the release page:
# https://github.com/arkenfox/user.js/releases/tag/v126.0
# Click the file, then click "Raw", then check the commit hash or use a release asset if available.
# Since arkenfox often doesn't provide SHA256 for the single file in releases, 
# we verify the Git Commit Hash instead for the 'master' branch at a specific point.
ARKENFOX_COMMIT="PUT_SPECIFIC_COMMIT_HASH_HERE" 
# Alternative: If using a release tag that has a zip asset, use the zip's SHA256.
# For this example, we will download the specific tag's user.js and verify its content hash.
EXPECTED_USERJS_SHA="PUT_SHA256_OF_RAW_USERJS_FILE_HERE"

# --------------------------------------------------

echo "=== Hardening Firefox with Arkenfox ${ARKENFOX_VERSION} ==="

# 1. Download arkenfox user.js (Pinned to specific tag/commit)
echo "Downloading arkenfox user.js..."
# Option A: Download by Tag (Recommended if release exists)
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
