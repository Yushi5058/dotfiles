#!/bin/bash
set -e

DOTFILES_DIR="$(cd "$(dirname "$0")/.." && pwd)"

if ! command -v chezmoi &>/dev/null; then
    echo "[-] Install chezmoi first: sudo pacman -S chezmoi"
    exit 1
fi

echo "[*] Deploying dotfiles from: $DOTFILES_DIR"
chezmoi init "$DOTFILES_DIR"
chezmoi apply
echo "[!] Done."
