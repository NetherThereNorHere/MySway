#!/usr/bin/env bash
set -euo pipefail

# --- CONFIGURATION: PINNED VERSIONS & CHECKSUMS ---
# Yazi v26.5.6 (Released May 2026)
YAZI_VERSION="v26.5.6"
YAZI_SHA="797abc8965c07d903f3cd263512fe4114b2fc36f03fc62011300787f28a48f1e" 
# ^ Note: Verify this hash matches the asset on the v26.5.6 release page before building.
# If the hash above is a placeholder, fetch the real one from:
# https://github.com/sxyazi/yazi/releases/tag/v26.5.6

# Nerd Fonts v3.4.0 (Released April 2025)
NERD_VERSION="v3.4.0"
# SHA256 for NerdFontsSymbolsOnly.zip v3.4.0
# You MUST verify this hash from the release page: https://github.com/ryanoasis/nerd-fonts/releases/tag/v3.4.0
# Example placeholder (Replace with actual hash from release assets):
NERD_SHA="PUT_ACTUAL_SHA256_HERE" 

# --------------------------------------------------

echo "=== Installing Pinned Yazi ${YAZI_VERSION} ==="

# Download Yazi
curl -L -o yazi.zip "https://github.com/sxyazi/yazi/releases/download/${YAZI_VERSION}/yazi-x86_64-unknown-linux-gnu.zip"

# Verify Yazi Checksum
echo "${YAZI_SHA}  yazi.zip" | sha256sum -c -
if [ $? -ne 0 ]; then
    echo "ERROR: Yazi checksum verification failed!"
    exit 1
fi

# Extract and Install
# Note: Newer Yazi zips extract to a directory named after the arch, e.g., yazi-x86_64-unknown-linux-gnu/
unzip -q yazi.zip
# Find the extracted directory (usually matches the zip content)
YAZI_DIR=$(unzip -l yazi.zip | awk 'NR==4 {print $4}' | cut -d'/' -f1)
mv "${YAZI_DIR}/yazi" /usr/bin/
mv "${YAZI_DIR}/ya" /usr/bin/

# Cleanup
rm -rf "${YAZI_DIR}" yazi.zip

# Record Version for Update Checker
echo "${YAZI_VERSION}" > /etc/yazi-version

echo "=== Installing Pinned Nerd Fonts ${NERD_VERSION} ==="

# Download Nerd Fonts
curl -L -o nerd-fonts.zip "https://github.com/ryanoasis/nerd-fonts/releases/download/${NERD_VERSION}/NerdFontsSymbolsOnly.zip"

# Verify Nerd Fonts Checksum
echo "${NERD_SHA}  nerd-fonts.zip" | sha256sum -c -
if [ $? -ne 0 ]; then
    echo "ERROR: Nerd Fonts checksum verification failed!"
    exit 1
fi

# Install Fonts
mkdir -p /usr/share/fonts/nerd-fonts-symbols
unzip -q nerd-fonts.zip -d /usr/share/fonts/nerd-fonts-symbols/
rm -f nerd-fonts.zip

# Record Version for Update Checker
echo "${NERD_VERSION}" > /etc/nerd-fonts-version

echo "Installation complete. Versions pinned:"
cat /etc/yazi-version
cat /etc/nerd-fonts-version
