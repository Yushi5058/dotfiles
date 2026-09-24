#!/usr/bin/env bash
# Sync packages from declarative lists (dot_config/packages/*.txt)
# Usage:  scripts/sync-packages.sh [--update]
#   --update   paru -Syu first, then ensure all declared packages are installed
# Reads:  dot_config/packages/base.txt   (pacman)
#         dot_config/packages/aur.txt    (AUR via paru)

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
BASE_LIST="$REPO_DIR/dot_config/packages/base.txt"
AUR_LIST="$REPO_DIR/dot_config/packages/aur.txt"

FAILURES=""

ok()   { echo -e "[+] $1"; }
fail() { echo -e "[-] $1"; }

# Ensure paru (AUR helper) is installed
if ! command -v paru >/dev/null 2>&1; then
    echo "[*] Installing paru..."
    if sudo pacman -S --noconfirm --needed paru 2>&1; then
        ok "paru installed"
    else
        fail "paru install FAILED — cannot continue"
        exit 1
    fi
fi

# Optional full system update
if [[ "${1:-}" == "--update" ]]; then
    echo "[*] paru -Syu..."
    paru -Syu --noconfirm 2>&1 || fail "system update FAILED"
fi

install_list() {
    local name="$1" file="$2" cmd="$3"
    if [[ ! -r "$file" ]]; then
        fail "$name list missing: $file"
        FAILURES="$FAILURES\n  - $name (list missing)"
        return
    fi
    echo "[*] $name ($(wc -l < "$file") packages)..."
    if $cmd < "$file" 2>&1; then
        ok "$name done"
    else
        fail "$name FAILED"
        FAILURES="$FAILURES\n  - $name"
    fi
}

install_list "pacman (base)" "$BASE_LIST" "sudo pacman -S --noconfirm --needed -"
install_list "AUR"           "$AUR_LIST"  "paru -S --noconfirm --skipreview --removemake --needed -"

# Yazi plugins via package manager
if command -v ya >/dev/null 2>&1; then
    echo "[*] Yazi plugins..."
    if ya pkg install 2>&1; then
        ok "Yazi plugins done"
    else
        fail "Yazi plugins FAILED"
        FAILURES="$FAILURES\n  - Yazi plugins"
    fi
else
    echo "[-] yazi/ya not found — skipped"
    FAILURES="$FAILURES\n  - Yazi plugins (yazi/ya missing)"
fi

# Enable services
echo "[*] Enabling services..."
sudo systemctl enable --now ly@tty2 2>&1 || fail "enable ly"
sudo systemctl enable --now vboxdrv 2>&1 || fail "enable vboxdrv"
sudo systemctl enable --now vboxservice 2>&1 || fail "enable vboxservice"
sudo systemctl enable --now ufw 2>&1 || fail "enable ufw"
sudo systemctl enable --now tlp 2>&1 || fail "enable tlp"
sudo systemctl mask --now power-profiles-daemon 2>&1 || fail "mask power-profiles-daemon"
sudo systemctl enable --now bluetooth 2>&1 || fail "enable bluetooth"

if [ -n "$FAILURES" ]; then
    echo -e "Some groups had failures:$FAILURES"
    exit 1
else
    echo "[+] All packages installed successfully."
fi