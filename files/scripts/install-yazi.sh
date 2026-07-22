#!/usr/bin/env bash
set -euo pipefail

# --- CONFIGURATION: PINNED VERSIONS & CHECKSUMS ---
YAZI_VERSION="v26.5.6"
YAZI_SHA="6c6c52a4b2648e179f917bdaa7c57e793d18561b380a8bfa025f10cd1b9b2ad1" 

NERD_VERSION="v3.4.0"
NERD_SHA="8e617904b980fe3648a4b116808788fe50c99d2d495376cb7c0badbd8a564c47" 

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
unzip -q yazi.zip -d yazi-temp

mv yazi-temp/*/yazi /usr/bin/
mv yazi-temp/*/ya /usr/bin/

# Cleanup
rm -rf yazi-temp yazi.zip

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
