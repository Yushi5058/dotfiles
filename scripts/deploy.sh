#!/bin/bash

# Define the dotfiles directory
DOTFILES_DIR="$HOME/dotfiles"

# 1. Pre-flight check: Ensure stow is installed
if ! command -v stow &>/dev/null; then
    echo "[-] Error: GNU Stow is not installed. Install it with: sudo pacman -S stow"
    exit 1
fi

echo "[*] Deploying dotfiles from: $DOTFILES_DIR"
cd "$DOTFILES_DIR" || {
    echo "[-] Directory not found. Exiting."
    exit 1
}

# 2. Loop through all directories
for dir in */; do
    # Remove trailing slash
    pkg="${dir%/}"

    # 3. Safety/Ignore List
    # We ignore the .git folder and any 'scripts' folder you might have
    if [[ "$pkg" == ".git" || "$pkg" == "scripts" || "$pkg" == "unused" ]]; then
        echo "[~] Skipping non-module: $pkg"
        continue
    fi

    # 4. Check if it's actually a directory (extra safety)
    if [ -d "$pkg" ]; then
        echo "[+] Restowing module: $pkg"

        # -R: Restow (unlinks and relinks)
        # -v: Verbose (useful for debugging)
        stow -R "$pkg"
    fi
done

echo "[!] Done! Your Arch/Sway environment is locked and loaded."
