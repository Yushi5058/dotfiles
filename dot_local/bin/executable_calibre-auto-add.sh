#!/usr/bin/env bash
set -euo pipefail

WATCH_DIR="${HOME}/Documents/books"
LIB="${HOME}/Calibre Library"
STATE="${HOME}/.local/state/calibre-auto-add/last_ts"

mkdir -p "$(dirname "$STATE")"

if [[ -f "$STATE" ]]; then
  last_ts=$(cat "$STATE")
else
  last_ts=0
fi

while IFS= read -r -d '' f; do
  mtime=$(stat -c %Y "$f" 2>/dev/null || echo 0)
  if (( mtime > last_ts )); then
    calibredb --library "$LIB" add "$f" >/dev/null 2>&1 || true
  fi
done < <(find "$WATCH_DIR" -name '*.epub' -print0)

latest=$(find "$WATCH_DIR" -name '*.epub' -printf '%T@\\n' 2>/dev/null | sort -rn | head -1 | cut -d. -f1 || echo "$(date +%s)")
echo "${latest:-$(date +%s)}" > "$STATE"
