#!/bin/bash
# CachyOS install script for CTF/Development setup

set -e

echo "Installing packages..."

# Core development
sudo pacman -S --noconfirm \
    git base-devel curl wget \
    neovim python python-pip nodejs npm \
    go rust \
    bat eza fd ripgrep fzf \
    zsh starship \
    foot \
    waybar mako sway swaylock swayidle \
    grim slurp wl-clipboard \
    brightnessctl playerctl \
    wireplumber pipewire \
    wlsunset \
    autotiling \
    cliphist \
    copyq \
    fuzzel \
    fastfetch \
    btop \
    yazi \
    zathura \
    tmux \
    ribosome \
    nwg-look \
    xdg-user-dirs

# CTF tools
sudo pacman -S --noconfirm \
    pwntools binutils gdb ghidra binwalk foremost \
    stegsolve radare2 \
    nmap netcat \
    hashcat john \
    zsh \
    tmux

# AUR packages (requires yay)
yay -S --noconfirm \
    librewolf \
    vesktop \
    whatsie \
    ghostty \
    python-adblock

# Dotfiles
cd ~
git clone https://github.com/Yushi5058/dotfiles.git
cd dotfiles
stow -v -t ~ bat btop foot fuzzel mako nvim pipewire ripgrep scripts starship stow sway swaylock systemd tmux vim waybar wireplumber yazi zathura zsh

# Bitwarden CLI
yay -S --noconfirm bitwarden

echo "Done! Restart your system."