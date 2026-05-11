#!/usr/bin/env bash
set -euo pipefail

echo "Configuring Sway autostart for new users..."

# Ensure the file exists before appending
touch /etc/skel/.zprofile

cat <<EOF >> /etc/skel/.zprofile

# Autostart Sway on TTY1
if [[ -z \$DISPLAY ]] && [[ \$(tty) = /dev/tty1 ]]; then
  exec sway
fi
EOF
