#!/usr/bin/env bash
set -euo pipefail

echo "Configuring Sway autostart for new users..."

# Ensure directory exists
mkdir -p /etc/skel

# Overwrite completely to prevent duplicate code blocks on daily image builds
cat << 'EOF' > /etc/skel/.zprofile
# Autostart Sway silently on TTY1
if [[ -z "$DISPLAY" ]] && [[ -z "$WAYLAND_DISPLAY" ]] && [[ "$(tty)" = "/dev/tty1" ]]; then
    # Redirect standard error to keep the framebuffer transition pristine
    exec sway >/dev/null 2>&1
fi
EOF
