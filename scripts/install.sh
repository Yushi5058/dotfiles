#!/bin/bash
# CachyOS install script for Development setup

set -e

echo "Installing packages..."

# Core development & Daily use
sudo pacman -S --noconfirm \
    git base-devel curl wget \
    neovim python python-pip nodejs npm bun \
    go rust zig \
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
    yazi azote zathura zathura-pdf-mupdf \
    tmux thunar \
    nwg-look \
    bluetui impala \
    dbeaver tree-sitter-cli \
    atuin croc git-delta github-cli \
    jless jq localsend ouch parallel \
    podman podman-compose ruff tldr tmate waydroid

# ThinkPad X1 / Laptop support
sudo pacman -S --noconfirm \
    sof-firmware intel-ucode \
    tlp power-profiles-daemon \
    acpi acpid \
    fprintd iio-sensor-proxy \
    intel-media-driver libva-intel-driver \
    vulkan-intel \
    bluez bluez-utils \
    pavucontrol \
    man-db man-pages \
    noto-fonts noto-fonts-emoji \
    gnome-keyring libsecret \
    xdg-desktop-portal xdg-desktop-portal-wlr \
    unzip unrar p7zip \
    exfatprogs ntfs-3g \
    reflector

# AUR packages (requires paru)
paru -S --noconfirm \
    librewolf-bin \
    zsh-antidote \
    vscodium-bin

# Dotfiles
cd ~
if [ ! -d "dotfiles" ]; then
    git clone https://github.com/Yushi5058/dotfiles.git
    cd dotfiles
else
    cd dotfiles
    git pull
fi

echo "Done! Don't forget to use restow-all function."
