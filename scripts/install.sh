#!/bin/bash
# Bootstrap script — delegates to chezmoi for dotfiles + optional packages

set -e

echo "[*] Installing chezmoi..."
if ! command -v chezmoi &>/dev/null; then
    sudo pacman -S --noconfirm chezmoi
fi

echo "[*] Cloning dotfiles..."
TARGET_USER="${SUDO_USER:-$USER}"
REPO_DIR="/home/$TARGET_USER/dotfiles"

if [ -d "$REPO_DIR/.git" ]; then
    sudo -u "$TARGET_USER" git -C "$REPO_DIR" pull
else
    sudo -u "$TARGET_USER" git clone https://codeberg.org/yushi_61/dotfiles.git "$REPO_DIR"
fi

echo "[*] Deploying dotfiles with chezmoi..."
sudo -u "$TARGET_USER" chezmoi init "$REPO_DIR"
sudo -u "$TARGET_USER" chezmoi apply

echo "[!] Done. Running chezmoi apply also triggers run_once_ scripts (package install, etc.)."
echo "    If sudo was needed, re-run: chezmoi apply"
