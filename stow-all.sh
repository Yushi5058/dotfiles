#!/bin/bash

DOTFILES_DIR="$HOME/dotfiles"

echo "Deploying dotfiles from: $DOTFILES_DIR"
cd "$DOTFILES_DIR" || { echo "Directory not found. Exiting."; exit 1; }

# Loop through all visible directories
for dir in */; do
    # Remove the trailing slash from the directory name
    pkg="${dir%/}"

    # Safety check: skip it if it is not a directory
    [ -d "$pkg" ] || continue

    echo "[+] Restowing: $pkg"
    stow -R "$pkg"
done

echo "Done! All modules successfully stowed."
