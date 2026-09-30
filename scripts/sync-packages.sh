#!/usr/bin/env bash
# Sync packages from declarative lists (dot_config/packages/*.txt)
# Usage:  scripts/sync-packages.sh [--update]
#   --update   paru -Syu first, then ensure all declared packages are installed
# Reads:  dot_config/packages/base.txt   (pacman)
#         dot_config/packages/aur.txt    (AUR via paru)
# Idempotent: already-installed packages are skipped, no sudo prompt when complete.
# the script is called from run_once_after_setup-packages.sh.tmpl on `chezmoi apply`.

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

# Snapshot of currently installed package names (exact match)
declare -A HAVE
for pkg in $(pacman -Qq); do
    HAVE["$pkg"]=1
done

install_list() {
    local name="$1" file="$2" cmd="$3"
    if [[ ! -r "$file" ]]; then
        fail "$name list missing: $file"
        FAILURES="$FAILURES\n  - $name (list missing)"
        return
    fi
    local total missing=()
    total=$(wc -l < "$file")
    while read -r pkg || [[ -n "$pkg" ]]; do
        [[ -z "$pkg" ]] && continue
        [[ -z "${HAVE[$pkg]+x}" ]] && missing+=("$pkg")
    done < "$file"
    if [[ ${#missing[@]} -eq 0 ]]; then
        ok "$name: all $total packages already installed — skipped"
        return
    fi
    echo "[*] $name: $total listed, ${#missing[@]} missing — installing..."
    if $cmd "${missing[@]}" 2>&1; then
        ok "$name done (${#missing[@]} installed)"
    else
        fail "$name FAILED"
        FAILURES="$FAILURES\n  - $name"
    fi
}

install_list "pacman (base)" "$BASE_LIST" "sudo pacman -S --noconfirm --needed"
install_list "AUR"           "$AUR_LIST"  "paru -S --noconfirm --skipreview --removemake --needed"

# Yazi plugins via package manager
# Stale ~/.cache/yazi/packages cache (created by older ya) can fail current
# ya's materialize() on monorepo LICENSE symlinks (ENAMETOOLONG). Purge+retry.
if command -v ya >/dev/null 2>&1; then
    echo "[*] Yazi plugins..."
    if ya pkg install 2>&1; then
        ok "Yazi plugins done"
    else
        echo "[*] ya pkg install failed — purging stale cache ($HOME/.cache/yazi/packages) and retrying..."
        rm -rf "$HOME/.cache/yazi/packages"
        if ya pkg install 2>&1; then
            ok "Yazi plugins done (after cache purge)"
        else
            fail "Yazi plugins FAILED"
            FAILURES="$FAILURES\n  - Yazi plugins"
        fi
    fi
else
    echo "[-] yazi/ya not found — skipped"
    FAILURES="$FAILURES\n  - Yazi plugins (yazi/ya missing)"
fi

# Enable services
echo "[*] Enabling services..."
sudo systemctl enable --now ly@tty2 2>&1 || fail "enable ly"
# vboxdrv/vboxservice units are absent in current Arch (module auto-loads via
# virtualbox-host-dkms) -> gate on presence so sync still exits 0
for svc in vboxdrv vboxservice; do
    if systemctl list-unit-files --quiet "$svc.service"; then
        sudo systemctl enable --now "$svc" 2>&1 || fail "enable $svc"
    else
        echo "[=] $svc.service not present — skipped (auto-loaded via DKMS)"
    fi
done
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