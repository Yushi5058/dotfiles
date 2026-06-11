#!/bin/bash
# Migration backup/restore script
# Usage:
#   ./scripts/backup.sh /mnt/usb backup    # backup current system to USB
#   ./scripts/backup.sh /mnt/usb restore   # restore from USB to new system

set -e

MODE="${2:-backup}"
BACKUP_DIR="${1:-/mnt/usb}"

case "$MODE" in
    backup)
        echo "=== Backing up to $BACKUP_DIR ==="
        mkdir -p "$BACKUP_DIR"

        echo "[1/6] Dotfiles..."
        cp -r ~/dotfiles "$BACKUP_DIR/" 2>/dev/null || true

        echo "[2/6] Documents..."
        rsync -a --info=progress2 ~/Documents "$BACKUP_DIR/" 2>/dev/null || cp -r ~/Documents "$BACKUP_DIR/" 2>/dev/null || true

        echo "[3/6] Pictures..."
        rsync -a --info=progress2 ~/Pictures "$BACKUP_DIR/" 2>/dev/null || cp -r ~/Pictures "$BACKUP_DIR/" 2>/dev/null || true

        echo "[4/6] LibreWolf profile..."
        cp -r ~/.librewolf "$BACKUP_DIR/librewolf" 2>/dev/null || true

        echo "[5/6] SSH keys & GPG (if present)..."
        cp -r ~/.ssh "$BACKUP_DIR/" 2>/dev/null || true
        cp -r ~/.gnupg "$BACKUP_DIR/" 2>/dev/null || true
        cp -r ~/.password-store "$BACKUP_DIR/" 2>/dev/null || true

        echo "[6/6] Package list..."
        pacman -Qq > "$BACKUP_DIR/pkglist.txt" 2>/dev/null || true
        pacman -Qqm > "$BACKUP_DIR/pkglist-aur.txt" 2>/dev/null || true

        echo ""
        echo "=== Backup complete ==="
        echo "Size: $(du -sh "$BACKUP_DIR" 2>/dev/null)"
        echo ""
        echo "Backup includes:"
        echo "  - ~/dotfiles             (configs, also on GitHub)"
        echo "  - ~/Documents"
        echo "  - ~/Pictures"
        echo "  - ~/.librewolf           (bookmarks, history, passwords)"
        echo "  - ~/.ssh                 (⚠️ sensitive)"
        echo "  - ~/.gnupg               (⚠️ sensitive)"
        echo "  - ~/.password-store      (⚠️ sensitive)"
        echo "  - Package lists          (pkglist.txt, pkglist-aur.txt)"
        echo ""
        echo "Restore options on new laptop:"
        echo "  USB:    ./scripts/backup.sh /mnt/usb restore"
        echo "  Net:    ./scripts/transfer.sh receive user@<old-laptop-ip>:/mnt/usb"
        echo ""
        echo "Then:"
        echo "  1. sudo ./scripts/install.sh"
        echo "  2. deploy: ./scripts/deploy.sh"
        ;;

    restore)
        echo "=== Restoring from $BACKUP_DIR ==="

        echo "[1/6] Dotfiles (skipped — will use deploy.sh)..."
        [ -d "$BACKUP_DIR/dotfiles" ] && echo "  available at $BACKUP_DIR/dotfiles"

        echo "[2/6] Documents..."
        cp -r "$BACKUP_DIR/Documents" ~/ 2>/dev/null || true

        echo "[3/6] Pictures..."
        cp -r "$BACKUP_DIR/Pictures" ~/ 2>/dev/null || true

        echo "[4/6] LibreWolf profile..."
        cp -r "$BACKUP_DIR/librewolf" ~/.librewolf 2>/dev/null || true

        echo "[5/6] SSH keys & GPG (manual — sensitive)..."
        if [ -d "$BACKUP_DIR/.ssh" ]; then
            echo "  SSH keys found:"
            ls "$BACKUP_DIR/.ssh/" 2>/dev/null
            echo "  Restore with: cp -r $BACKUP_DIR/.ssh ~/"
        fi
        if [ -d "$BACKUP_DIR/.gnupg" ]; then
            echo "  GPG keys found at $BACKUP_DIR/.gnupg"
            echo "  Restore with: cp -r $BACKUP_DIR/.gnupg ~/"
        fi
        if [ -d "$BACKUP_DIR/.password-store" ]; then
            echo "  Password store found at $BACKUP_DIR/.password-store"
            echo "  Restore with: cp -r $BACKUP_DIR/.password-store ~/"
        fi

        echo "[6/6] Package lists..."
        if [ -f "$BACKUP_DIR/pkglist.txt" ]; then
            echo "  pkglist.txt — install with:"
            echo "  sudo pacman -S --needed --noconfirm - < $BACKUP_DIR/pkglist.txt"
        fi
        if [ -f "$BACKUP_DIR/pkglist-aur.txt" ]; then
            echo "  pkglist-aur.txt — install with:"
            echo "  paru -S --needed --skipreview --noconfirm - < $BACKUP_DIR/pkglist-aur.txt"
        fi

        echo ""
        echo "=== Restore complete ==="
        echo "Run ./scripts/deploy.sh to symlink dotfiles."
        ;;

    *)
        echo "Usage: $0 <mountpoint> {backup|restore}"
        echo "  backup  — copy files FROM this system TO the USB"
        echo "  restore — copy files FROM the USB TO this system"
        exit 1
        ;;
esac
