#!/bin/bash
# Backup script for system migration

BACKUP_DIR="${1:-/media/backup}"

echo "Backing up to $BACKUP_DIR..."
mkdir -p "$BACKUP_DIR"

# Dotfiles (GitHub, but backup anyway)
cp -r ~/dotfiles "$BACKUP_DIR/" 2>/dev/null

# Documents
cp -r ~/Documents "$BACKUP_DIR/" 2>/dev/null

# LibreWolf (bookmarks, history)
cp -r ~/.librewolf "$BACKUP_DIR/librewolf" 2>/dev/null

echo "Done! Size: $(du -sh "$BACKUP_DIR" 2>/dev/null)"

echo ""
echo "Manual backup needed:"
echo "  - ~/.ssh/keys"
echo "  - Bitwarden (export from web vault)"