#!/bin/bash
# CachyOS install script for CTF/Development setup

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

# CTF tools
sudo pacman -S --noconfirm \
    pwntools binutils gdb ghidra binwalk foremost \
    stegsolve radare2 \
    nmap openbsd-netcat \
    hashcat john \
    audacity sonic-visualiser \
    apk-tools checksec debtap \
    fcrackzip upx hexedit socat \
    jadx volatility3 ltrace strace \
    perl-image-exiftool pwndbg \
    sleuthkit testdisk sqlmap steghide \
    wireshark-qt zbar icestorm-git iverilog

# AUR packages (requires paru)
paru -S --noconfirm \
    librewolf-bin \
    burpsuite \
    android-apktool-bin \
    bkcrack-bin \
    cewl-git \
    zsteg \
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
