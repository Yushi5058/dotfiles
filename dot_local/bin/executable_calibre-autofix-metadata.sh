#!/usr/bin/env bash
set -euo pipefail

WATCH_DIR="${HOME}/Documents/books"
LIB="${HOME}/Calibre Library"
STATE="${HOME}/.local/state/calibre-autofix/last_ts"

mkdir -p "$(dirname "$STATE")"
[[ -f "$STATE" ]] && last_ts=$(cat "$STATE") || last_ts=0

while IFS= read -r -d '' f; do
    mtime=$(stat -c %Y "$f" 2>/dev/null || echo 0)
    if ((mtime > last_ts)); then
        echo "Processing: $(basename "$f")"

        # 1. Add file to Calibre temporarily and capture its newly assigned book ID
        bid=$(calibredb --library "$LIB" add "$f" 2>&1 | grep -oE '[0-9]+' | head -1 || true)

        if [[ -n "$bid" ]]; then
            # 2. Query online providers (Google Books, Goodreads, ISBNdb) to populate metadata
            calibredb --library "$LIB" download_metadata --book-id "$bid" >/dev/null 2>&1 || true

            # 3. Write downloaded metadata and cover image directly into the Calibre copy
            calibredb --library "$LIB" embed_metadata "$bid" >/dev/null 2>&1 || true

            # 4. Overwrite your original file in WATCH_DIR with the fully tagged copy
            calibredb --library "$LIB" export "$bid" --to-dir "/tmp/calibre_export_$bid" --dont-save-cover --dont-write-opf >/dev/null 2>&1 || true

            # Find the exported file and replace the original file
            ext="${f##*.}"
            exported_file=$(find "/tmp/calibre_export_$bid" -type f -name "*.$ext" | head -1 || true)
            if [[ -n "$exported_file" ]]; then
                mv "$exported_file" "$f"
                rm -rf "/tmp/calibre_export_$bid"
                echo "Successfully enriched metadata for: $(basename "$f")"
            fi

            # (Optional) Remove temporary record from Calibre if you only want the standalone file
            # calibredb --library "$LIB" remove "$bid" >/dev/null 2>&1 || true
        fi
    fi
done < <(find "$WATCH_DIR" -type f \( -name '*.epub' -o -name '*.pdf' \) -print0)

# Update state timestamp
latest=$(find "$WATCH_DIR" -type f \( -name '*.epub' -o -name '*.pdf' \) -printf '%T@\n' 2>/dev/null | sort -rn | head -1 | cut -d. -f1 || echo "$(date +%s)")
echo "${latest:-$(date +%s)}" >"$STATE"
