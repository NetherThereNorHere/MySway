#!/usr/bin/env bash
set -euo pipefail

echo "Fetching the latest pre-compiled wayland-pipewire-idle-inhibit binary..."

# DOWNLOAD STEP: Pull the real Linux release asset from the developer's repository
curl -L "https://github.com/rafaelrc7/wayland-pipewire-idle-inhibit.git" -o /tmp/inhibitor.tar.gz

# EXTRACT STEP: Unpack the standalone tool into the system directory
tar -xzf /tmp/inhibitor.tar.gz -C /usr/bin/

# PERMISSIONS STEP: Grant execution access to the final system layer
chmod +x /usr/bin/wayland-pipewire-idle-inhibit

echo "Binary successfully injected into /usr/bin/!"
