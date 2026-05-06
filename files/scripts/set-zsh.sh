#!/usr/bin/env bash
set -euo pipefail

# Set Zsh as the default for the 'skeleton' (newly created users)
sed -i 's/SHELL=\/bin\/bash/SHELL=\/usr\/bin\/zsh/' /etc/default/useradd

# Update existing users (like the initial user created during install)
# This finds users with a UID of 1000 or higher and changes their shell to zsh
for user in $(awk -F: '$3 >= 1000 && $3 != 65534 {print $1}' /etc/passwd); do
    usermod --shell /usr/bin/zsh "$user"
done
