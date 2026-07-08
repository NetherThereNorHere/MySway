#!/usr/bin/env bash
set -euo pipefail

# 1. Dynamically target the /latest/ API endpoint to fetch the newest release automatically
curl -L -O https://github.com/sxyazi/yazi/releases/latest/download/yazi-x86_64-unknown-linux-gnu.zip

# 2. Extract the file into a temporary layout space
unzip -q yazi-x86_64-unknown-linux-gnu.zip -d yazi-temp

# 3. Overwrite the older binaries inside the global system path
mv yazi-temp/*/yazi /usr/bin/
mv yazi-temp/*/ya /usr/bin/

# 4. Wipe out the temporary setup files cleanly
rm -rf yazi-temp yazi-x86_64-unknown-linux-gnu.zip
