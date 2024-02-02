#!/bin/bash

set -eufo pipefail
echo -e "\033[0;32m>>>>> Begin Setting Up Arch Linux Packages <<<<<\033[0m"

# Function to install package using pacman or yay if available
install_package() {
    if pacman -Q "$1" &>/dev/null || yay -Q "$1" &>/dev/null; then
        echo "$1 is already installed."
    else
        if pacman -Qi yay &>/dev/null; then
            yay -S --noconfirm "$1"
        else
            sudo pacman -S --noconfirm "$1"
        fi
    fi
}

# Install applications using pacman, yay, or flatpak
install_package spotify
install_package kitty
install_package obsidian
install_package firefox
install_package whatsie
install_package discord
install_package krita
install_package caffeine-ng
install_package flameshot
install_package neovim
install_package btop
install_package bat
install_package eza
install_package zsh
install_package zellij
install_package nodejs
install_package ripgrep
install_package fd
install_package xplr
install_package kvantum

# Install applications via Flatpak if not found
if ! command -v spotify &>/dev/null; then
    echo "Installing Spotify via Flatpak"
    flatpak install flathub com.spotify.Client -y
fi

if ! command -v obsidian &>/dev/null; then
    echo "Installing Obsidian via Flatpak"
    flatpak install flathub md.obsidian.Obsidian -y
fi

echo -e "\033[0;32m>>>>> Finish Setting Up Arch Linux Packages <<<<<\033[0m"
