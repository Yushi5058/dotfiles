#!/bin/bash
# Backup script for system migration

BACKUP_DIR="/media/backup"  # Change to your external drive/partition

echo "Starting backup to $BACKUP_DIR..."

mkdir -p "$BACKUP_DIR"

# Dotfiles
echo "Backing up dotfiles..."
cp -r ~/dotfiles "$BACKUP_DIR/" 2>/dev/null || echo "No dotfiles to backup"

# Documents
echo "Backing up documents..."
cp -r ~/Documents "$BACKUP_DIR/" 2>/dev/null || echo "No Documents"

# Downloads (optional - may be large)
# cp -r ~/Downloads "$BACKUP_DIR/"

# Pictures
echo "Backing up pictures..."
cp -r ~/Pictures "$BACKUP_DIR/" 2>/dev/null || echo "No Pictures"

# Configs not in dotfiles
echo "Backing up config files..."
cp -r ~/.config/librewolf "$BACKUP_DIR/" 2>/dev/null
cp -r ~/.cache/yay "$BACKUP_DIR/" 2>/dev/null

# SSH keys
echo "Backing up SSH keys..."
mkdir -p "$BACKUP_DIR/.ssh"
cp -r ~/.ssh/* "$BACKUP_DIR/.ssh/" 2>/dev/null

# Password store
cp -r ~/.password-store "$BACKUP_DIR/" 2>/dev/null

# Browser profiles
cp -r ~/.librewolf "$BACKUP_DIR/" 2>/dev/null

echo "Backup complete!"
du -sh "$BACKUP_DIR"