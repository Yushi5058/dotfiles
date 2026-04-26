#!/bin/bash
# CachyOS install script for CTF/Development setup

set -e

echo "Installing packages..."

# Core development
sudo pacman -S --noconfirm \
    git base-devel curl wget \
    neovim python python-pip nodejs npm bun \
    go rust \
    bat eza fd ripgrep fzf \
    zsh starship \
    ghostty \
    waybar mako sway swaylock \
    grim slurp wl-clipboard \
    brightnessctl playerctl \
    wireplumber pipewire \
    wlsunset \
    autotiling \
    cliphist \
    fuzzel \
    fastfetch \
    btop \
    yazi azote zathura \
    tmux thunar \
    nwg-look

# CTF tools
sudo pacman -S --noconfirm \
    pwntools binutils gdb ghidra binwalk foremost \
    stegsolve radare2 \
    nmap netcat \
    hashcat john \
    audacity sonic-visualizer \
    zsh \
    tmux

# AUR packages (requires paru)
paru -S --noconfirm \
    librewolf \
    vesktop \
    ghostty

# Dotfiles
cd ~
git clone https://github.com/Yushi5058/dotfiles.git
cd dotfiles

echo "Done! Don't forget to use restow-all function."
