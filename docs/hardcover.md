# Hardcover reading-progress sync

`dot_local/bin/hardcover-sync.py.tmpl` → `~/.local/bin/hardcover-sync.py`

Pushes reading progress from **Moon+ Reader** (Android, synced to the laptop) to [Hardcover](https://hardcover.app). Uses the **calibre library as the source of truth for book identity** (ISBN/title), so matches land on the right Hardcover edition.

## Setup

1. **API key** — create at <https://hardcover.app/account/api> (`hc_pat_...`). Store in machine-local config (`~/.config/chezmoi/chezmoi.toml`, NOT in this repo):

   ```toml
   [data]
   hardcover_api_key = "hc_pat_..."
   ```

   The script template interpolates `{{ .hardcover_api_key }}`; the env var `HARDCOVER_API_KEY` overrides it. The literal key never touches this repo — `chezmoi.toml` is gitignored by convention (machine-local secrets).

2. **Calibre library** — default `~/Calibre Library` (override: `CALIBRE_LIBRARY` env). Metadata drives the match, so keep ISBN/title clean.

3. **Progress source** — currently configured to read Moon+ Reader `.po` cache files from `MOONREADER_DIR` (default `~/Sync/Books`). Recursively scans for newest `.po` and extracts progress. Adjust `MOONREADER_DIR` if your sync location differs. (MoonReader cache dirs were removed; Readest may need a different adapter in future.)

## Usage

```bash
hardcover-sync.py              # auto-detect latest read, refresh nothing
hardcover-sync.py --refresh-calibre   # re-import metadata from files first
hardcover-sync.py --dry-run           # show what would be pushed
hardcover-sync.py --book "Title" --fraction 0.42   # manual override
```

Behavior:
- **forward-only** — skips if local progress < HardCover progress (no regressions)
- **ISBN-first matching** — calibre ISBN searched on HardCover, falls back to title+author, then title-only
- **auto-marks Currently Reading** if the book is in your library (status 2)
- exits with clear message if the book isn't in your HardCover library (add it on the website, set status: Currently Reading)

## Automation (systemd user timers — two-tier)

Progress pushed **every 10 min** (accurate through the day, like Readest); calibre
metadata re-imported **daily**:

```bash
systemctl --user enable --now hardcover-sync.timer          # every 10 min
systemctl --user enable --now hardcover-sync-refresh.timer  # daily + calibredb refresh
systemctl --user list-timers 'hardcover-*'                  # verify scheduled
journalctl --user -u hardcover-sync.service                 # last run log
```

Units in `~/.config/systemd/user/`:

| Unit | Schedule | Action |
|---|---|---|
| `hardcover-sync.service` + `.timer` | every 10 min | detect + push progress (forward-only) |
| `hardcover-sync-refresh.service` + `.timer` | daily (+0–10 min) | `--refresh-calibre` then same push |

Why two tiers: progress sync every 10 min is cheap (identity lookup only, no
metadata rebuild). `calibredb refresh` is heavier — once a day is enough for
new books. Both use `--quiet`: no reading progress found → exit 0 (never a
failed unit on empty days). `Persistent=true` catches up missed runs.