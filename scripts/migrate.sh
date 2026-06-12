#!/bin/bash
# Migrate files from old laptop to new laptop via croc + 7z
# Usage (on OLD laptop): ./scripts/migrate.sh
#
# On the NEW laptop, manually run:
#   croc <code> --yes --out - | 7z x -si -aoa

set -e

ARCHIVE="/tmp/migration-$(date +%Y%m%d-%H%M%S).7z"
ITEMS="Documents .librewolf .ssh .gnupg"

echo "=== Migration Packer ==="
echo ""

missing=0
for item in $ITEMS; do
    if [ -d ~/"$item" ]; then
        echo "  [✓] ~/$item"
    else
        echo "  [ ] ~/$item (not found)"
    fi
done

echo ""
echo "[*] Creating 7z archive..."
if ! 7z a -mx=3 "$ARCHIVE" $(for d in $ITEMS; do [ -d ~/"$d" ] && echo ~/"$d"; done) >/dev/null; then
    echo "[-] Failed to create archive"
    exit 1
fi

SIZE=$(du -h "$ARCHIVE" | cut -f1)
echo "[+] Archive created: $ARCHIVE ($SIZE)"

echo ""
echo "[*] Sending via croc..."
if croc send "$ARCHIVE"; then
    echo ""
    echo "[+] Transfer verified — file was received."
else
    echo ""
    echo "[-] Transfer failed or was interrupted."
    exit 1
fi

rm -f "$ARCHIVE"

echo ""
echo "=== Migration complete ==="
echo ""
echo "To verify, on the new laptop run in ~/:"
echo ""
echo "  croc <code> --yes --out - | 7z x -si -aoa"
echo ""
echo "This will extract Documents/, .librewolf/, .ssh/, .gnupg/"
echo "into your home directory."
