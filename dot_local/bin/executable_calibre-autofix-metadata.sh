#!/usr/bin/env bash
set -euo pipefail

WATCH_DIR="${HOME}/Documents/books"
LIB="${HOME}/Calibre Library"
STATE="${HOME}/.local/state/calibre-autofix/last_ts"

mkdir -p "$(dirname "$STATE")"

if [[ -f "$STATE" ]]; then
	last_ts=$(cat "$STATE")
else
	last_ts=0
fi

# Build set of book IDs that have at least one format under WATCH_DIR
# We'll also collect file->hash to detect changes? simpler: track by mtime for new files
# 1) Process new/modified files (by mtime > last_ts)
while IFS= read -r -d '' f; do
	mtime=$(stat -c %Y "$f" 2>/dev/null || echo 0)
	if ((mtime > last_ts)); then
		calibredb --library "$LIB" add --automerge=ignore "$f" >/dev/null 2>&1 || calibredb --library "$LIB" add "$f" >/dev/null 2>&1 || true
	fi
done < <(find "$WATCH_DIR" \( -name '*.epub' -o -name '*.pdf' \) -print0)

# 2) Verify and autofix existing books whose formats are under WATCH_DIR
python3 -c "
import json, os, subprocess, sys

watch = os.path.expanduser('${WATCH_DIR}')
lib = os.path.expanduser('${LIB}')

# get all books with formats
try:
    p = subprocess.run(['calibredb', '--library', lib, 'list', '--fields', 'id,title,authors,identifiers,isbn,publisher,tags,formats', '--for-machine'], 
                       capture_output=True, text=True, check=True)
    books = json.loads(p.stdout)
except Exception as e:
    sys.exit(0)

for b in books:
    formats = b.get('formats') or []
    # check if any format under watch dir
    under_watch = False
    for fm in formats:
        try:
            if os.path.commonpath([watch, fm]) == watch:
                under_watch = True
                break
        except Exception:
            pass
    if not under_watch:
        continue

    # check if needs fixing: missing title/author or very sparse
    needs = False
    title = (b.get('title') or '').strip()
    authors = b.get('authors') or []
    identifiers = b.get('identifiers') or {}
    tags = b.get('tags') or []
    isbn = (b.get('isbn') or '').strip()
    publisher = (b.get('publisher') or '').strip()

    if not title or title.lower().startswith('unknown') or len(title) < 2:
        needs = True
    if len(authors) == 0:
        needs = True
    # sparse if no identifiers/isbn and no cover? hard to detect without cover field; also few tags+no publisher
    if not needs:
        if not isbn and len(identifiers) == 0 and not publisher and len(tags) < 2:
            needs = True

    if needs:
        bid = b['id']
        try:
            # try to download metadata for this book id
            subprocess.run(['calibredb', '--library', lib, 'download_metadata', '--book-id', str(bid)], 
                          stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL, timeout=120)
        except Exception:
            pass
" >/dev/null 2>&1 || true

latest=$(find "$WATCH_DIR" \( -name '*.epub' -o -name '*.pdf' \) -printf '%T@\\n' 2>/dev/null | sort -rn | head -1 | cut -d. -f1 || echo "$(date +%s)")
echo "${latest:-$(date +%s)}" >"$STATE"
