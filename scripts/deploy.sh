#!/bin/bash

# Detect dotfiles root from script location (scripts/deploy.sh -> parent dir)
DOTFILES_DIR="$(cd "$(dirname "$0")/.." && pwd)"

# 1. Pre-flight check: Ensure chezmoi is installed
if ! command -v chezmoi &>/dev/null; then
    echo "[-] Error: chezmoi is not installed."
    echo "    Install it with: sudo pacman -S chezmoi"
    exit 1
fi

echo "[*] Deploying dotfiles from: $DOTFILES_DIR"
echo "[*] Using chezmoi to apply all dotfiles..."

# 2. Initialize chezmoi with the local repo path
chezmoi init "$DOTFILES_DIR"

# 3. Apply all dotfiles
chezmoi apply

echo "[!] Done! All dotfiles deployed with chezmoi."
