#!/bin/bash
# CachyOS install script for Development setup

FAILURES=""

install_pacman() {
    local group="$1"
    shift
    echo "[*] $group..."
    if sudo pacman -S --noconfirm --needed "$@" 2>&1; then
        echo "[+] $group - done"
    else
        echo "[-] $group - FAILED (some packages may be missing)"
        FAILURES="$FAILURES\n  - $group"
    fi
}

install_aur() {
    local group="$1"
    shift
    echo "[*] $group..."
    local cmd=(paru -S --noconfirm --skipreview --removemake --needed "$@")
    if [[ -n "$SUDO_USER" ]]; then
        cmd=(sudo -u "$SUDO_USER" "${cmd[@]}")
    fi
    if "${cmd[@]}" 2>&1; then
        echo "[+] $group - done"
    else
        echo "[-] $group - FAILED"
        FAILURES="$FAILURES\n  - $group"
    fi
}

# 1. Bootstrap: ensure paru and chezmoi are installed
if ! command -v paru &>/dev/null; then
    install_pacman "Installing paru chezmoi" paru chezmoi
else
    install_pacman "Install chezmoi" chezmoi
fi

# Core development & Daily use
install_pacman "Languages & build tools" \
    git base-devel curl wget \
    neovim python python-pip nodejs npm \
    go rust zig

install_pacman "Shell & terminal" \
    zsh starship ghostty

install_pacman "Sway environment" \
    waybar mako sway \
    grim slurp wl-clipboard \
    brightnessctl playerctl \
    wireplumber pipewire pipewire-alsa pipewire-jack pipewire-pulse \
    wlsunset cliphist fuzzel \
    wlr-randr xdg-desktop-portal-gtk \
    qt5-wayland qt6-wayland qt5ct qt6ct kvantum kvantum-qt5 \
    udiskie copyq swaybg

install_pacman "CLI tools" \
    bat eza fd ripgrep fzf \
    fastfetch btop \
    keychain \
    atuin croc git-delta github-cli \
    jless jq lazygit ouch parallel \
    p7zip tldr tmux zoxide

install_pacman "File managers & utilities" \
    yazi azote zathura zathura-pdf-mupdf thunar

install_pacman "Database & editors" \
    dbeaver tree-sitter-cli

install_pacman "Containers & networking" \
    podman podman-compose waydroid localsend tmate

install_pacman "System tools" \
    earlyoom zram-generator ufw pacman-contrib \
    polkit-gnome ly

# ThinkPad / Laptop support (X13 Yoga, X1 Carbon, etc.)
install_pacman "Laptop / ThinkPad" \
    sof-firmware intel-ucode \
    tlp power-profiles-daemon \
    acpi acpid \
    intel-media-driver libva-intel-driver \
    vulkan-intel \
    bluez bluez-utils blueman \
    pavucontrol bolt

install_pacman "Misc system" \
    man-db man-pages \
    noto-fonts noto-fonts-emoji noto-fonts-cjk \
    gnome-keyring libsecret \
    xdg-desktop-portal xdg-desktop-portal-wlr \
    unzip unrar p7zip \
    exfatprogs ntfs-3g \
    reflector \
    iwd wireless_tools

# Fonts
install_pacman "Fonts" \
    ttf-jetbrains-mono-nerd \
    ttf-ubuntu-font-family \
    ttf-font-awesome

# Virtualization
install_pacman "Virtualization" \
    virt-manager libvirt qemu-desktop edk2-ovmf dnsmasq

# AUR packages
install_aur "AUR: Sway extras" \
    autotiling nwg-look wl-clip-persist swaylock-effects-git tela-circle-icon-theme poweralertd

install_aur "AUR: Apps" \
    bluetui discord impala librewolf-bin tea vscodium-bin

install_aur "AUR: Shell & fonts" \
    rose-pine-cursor maplemono-ttf

# Make zsh the default shell
TARGET_USER="${SUDO_USER:-$USER}"
if [[ "$(getent passwd "$TARGET_USER" | cut -d: -f7)" != "$(which zsh)" ]]; then
    echo "[*] Setting zsh as default shell for $TARGET_USER..."
    chsh -s "$(which zsh)" "$TARGET_USER"
fi

# Dotfiles — clone or pull
TARGET_USER="${SUDO_USER:-$USER}"
if git -C "$(dirname "$0")" rev-parse --git-dir &>/dev/null; then
    sudo -u "$TARGET_USER" git -C "$(dirname "$0")" pull
else
    sudo -u "$TARGET_USER" git clone https://codeberg.org/yushi_61/dotfiles.git "/home/$TARGET_USER/dotfiles"
fi

# Deploy dotfiles with chezmoi
echo "[*] Deploying dotfiles with chezmoi..."
sudo -u "$TARGET_USER" chezmoi init "/home/$TARGET_USER/dotfiles"
sudo -u "$TARGET_USER" chezmoi apply

# Enable services
echo "[*] Enabling services..."
sudo systemctl enable --now ly@tty2 2>&1 || echo "[-] Failed to enable ly"
sudo systemctl enable --now libvirtd 2>&1 || echo "[-] Failed to enable libvirtd"
sudo systemctl enable --now power-profiles-daemon 2>&1 || echo "[-] Failed to enable power-profiles-daemon"

if [ -n "$FAILURES" ]; then
    echo "----------------------------"
    echo "Some groups had failures:"
    echo -e "$FAILURES"
    echo "Run the script again or install these manually."
else
    echo "[+] All packages installed successfully."
fi

echo "Done! Dotfiles deployed with chezmoi."
