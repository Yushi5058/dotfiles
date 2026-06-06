#!/bin/bash
# CachyOS install script for Development setup

set -e

echo "Installing packages..."

# Core development & Daily use
sudo pacman -S --noconfirm \
    git base-devel curl wget \
    neovim python python-pip nodejs npm \
    go rust zig \
    bat eza fd ripgrep fzf \
    zsh starship \
    ghostty \
    waybar mako sway \
    grim slurp wl-clipboard \
    brightnessctl playerctl \
    wireplumber pipewire pipewire-alsa pipewire-jack pipewire-pulse \
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
    jless jq lazygit localsend ouch parallel \
    podman podman-compose ruff tldr tmate waydroid \
    earlyoom zram-generator ufw pacman-contrib \
    polkit-gnome ly \
    wl-clip-persist wlr-randr \
    xdg-desktop-portal-gtk \
    qt5-wayland qt6-wayland qt5ct qt6ct kvantum kvantum-qt5 \
    udiskie

# ThinkPad X1 / Laptop support
sudo pacman -S --noconfirm \
    sof-firmware intel-ucode \
    tlp power-profiles-daemon \
    acpi acpid \
    fprintd iio-sensor-proxy \
    intel-media-driver libva-intel-driver \
    vulkan-intel \
    bluez bluez-utils blueman \
    pavucontrol \
    man-db man-pages \
    noto-fonts noto-fonts-emoji noto-fonts-cjk \
    gnome-keyring libsecret \
    xdg-desktop-portal xdg-desktop-portal-wlr \
    unzip unrar p7zip \
    exfatprogs ntfs-3g \
    reflector

# Fonts
sudo pacman -S --noconfirm \
    ttf-jetbrains-mono-nerd \
    ttf-ubuntu-font-family \
    ttf-font-awesome \
    woff2-font-awesome

# Virtualization
sudo pacman -S --noconfirm \
    virt-manager libvirt

# AUR packages (requires paru)
paru -S --noconfirm \
    librewolf-bin \
    zsh-antidote \
    vscodium-bin \
    swaylock-effects-git \
    rose-pine-cursor \
    maplemono-ttf

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
