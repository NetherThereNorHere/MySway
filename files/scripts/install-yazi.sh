#!/usr/bin/env bash
set -euo pipefail

curl -L -O https://github.com/sxyazi/yazi/releases/latest/download/yazi-x86_64-unknown-linux-gnu.zip

unzip -q yazi-x86_64-unknown-linux-gnu.zip -d yazi-temp

mv yazi-temp/*/yazi /usr/bin/
mv yazi-temp/*/ya /usr/bin/

rm -rf yazi-temp yazi-x86_64-unknown-linux-gnu.zip

# Get symbol icons for Yazi
echo "Fetching latest Symbols Only Nerd Font release..."

curl -L -O https://github.com/ryanoasis/nerd-fonts/releases/latest/download/NerdFontsSymbolsOnly.zip

mkdir -p /usr/share/fonts/nerd-fonts-symbols

unzip -q NerdFontsSymbolsOnly.zip -d /usr/share/fonts/nerd-fonts-symbols/

rm -f NerdFontsSymbolsOnly.zip
