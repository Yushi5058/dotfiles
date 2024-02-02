#!/bin/bash

# Check if zsh is installed
if ! command -v zsh &>/dev/null; then
    echo "zsh is not installed. Please install zsh first."
    exit 1
fi

# Change default shell to zsh
chsh -s $(which zsh)

echo "Default shell changed to zsh."

# Run zap update to update and install plugins
echo "Running 'zap update' to update and install Zsh plugins..."
zap update all

echo "Please log out and log back in for changes to take effect."

