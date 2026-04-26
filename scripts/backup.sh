#!/bin/bash
# Backup script for system migration
# ⚠️ Run manually, don't commit sensitive data to git

BACKUP_DIR="${1:-/media/backup}"  # Pass backup dir as arg

echo "Starting backup to $BACKUP_DIR..."
mkdir -p "$BACKUP_DIR"

# Dotfiles
echo "Backing up dotfiles..."
cp -r ~/dotfiles "$BACKUP_DIR/" 2>/dev/null || echo "No dotfiles"

# Documents
echo "Backing up documents..."
cp -r ~/Documents "$BACKUP_DIR/" 2>/dev/null || echo "No Documents"

# Pictures
echo "Backing up pictures..."
cp -r ~/Pictures "$BACKUP_DIR/" 2>/dev/null || echo "No Pictures"

# LibreWolf profile (non-sensitive: bookmarks, history, cookies)
echo "Backing up LibreWolf profile..."
cp -r ~/.librewolf "$BACKUP_DIR/librewolf" 2>/dev/null || echo "No LibreWolf"

# Screenshots (if any)
echo "Backing up screenshots..."
cp -r ~/Screenshots "$BACKUP_DIR/" 2>/dev/null || echo "No Screenshots"

echo "Backup complete!"
echo "Size: $(du -sh "$BACKUP_DIR" 2>/dev/null)"

echo ""
echo "⚠️ MANUAL BACKUP NEEDED (not in this script):"
echo "  - ~/.ssh/keys (keep private!)"
echo "  - ~/.password-store (keep private!)"
echo "  - Bitwarden vault (export from web vault as JSON)"
echo "  - ~/Downloads (optional, may be large)"