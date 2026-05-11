#!/usr/bin/env bash
set -euo pipefail

echo "Configuring Sway autostart..."
cat <<EOF >> /etc/zprofile

# Autostart Sway on TTY1
if [[ -z \$DISPLAY ]] && [[ \$(tty) = /dev/tty1 ]]; then
  exec sway
fi
EOF
