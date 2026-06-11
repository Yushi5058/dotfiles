#!/bin/bash
# Network-based file transfer between old and new laptop
# Usage:
#   On the OLD laptop (source):  ./scripts/transfer.sh send <user>@<new-ip>:<dest>
#   On the NEW laptop (target):  ./scripts/transfer.sh receive <user>@<old-ip>:<src>

set -e

MODE="$1"
TARGET="$2"

if [[ -z "$MODE" || -z "$TARGET" ]]; then
    echo "Usage:"
    echo "  OLD laptop → run this to send files TO the new laptop:"
    echo "    $0 send user@<new-laptop-ip>:<dest-path>"
    echo ""
    echo "  NEW laptop → run this to pull files FROM the old laptop:"
    echo "    $0 receive user@<old-laptop-ip>:<src-path>"
    exit 1
fi

# Strip the host:path into parts
REMOTE="${TARGET%:*}"
REMOTE_PATH="${TARGET#*:}"

case "$MODE" in
    send)
        echo "[*] Sending files to $REMOTE:$REMOTE_PATH..."
        rsync -avz --progress \
            ~/Documents \
            ~/Pictures \
            ~/.librewolf \
            ~/.ssh \
            ~/.gnupg \
            ~/.password-store \
            "$REMOTE:$REMOTE_PATH/" \
            2>&1 || echo "[-] Some files failed"
        echo "[+] Done"
        ;;
    receive)
        echo "[*] Receiving files from $REMOTE:$REMOTE_PATH..."
        rsync -avz --progress \
            "$REMOTE:$REMOTE_PATH/Documents" \
            "$REMOTE:$REMOTE_PATH/Pictures" \
            "$REMOTE:$REMOTE_PATH/.librewolf" \
            "$REMOTE:$REMOTE_PATH/.ssh" \
            "$REMOTE:$REMOTE_PATH/.gnupg" \
            "$REMOTE:$REMOTE_PATH/.password-store" \
            ~/ \
            2>&1 || echo "[-] Some files failed"
        echo "[+] Done"
        ;;
    *)
        echo "Unknown mode: $MODE"
        echo "Use 'send' or 'receive'"
        exit 1
        ;;
esac
