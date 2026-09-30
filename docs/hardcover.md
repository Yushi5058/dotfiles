# Hardcover reading-progress sync

`dot_local/bin/hardcover-sync.py.tmpl` → `~/.local/bin/hardcover-sync.py`

Pushes reading progress from **Foliate** to [Hardcover](https://hardcover.app). Uses the **calibre library as the source of truth for book identity** (ISBN/title), so matches land on the right Hardcover edition. Book files sync between devices via Syncthing; the reader is Foliate-only.

## Setup

1. **API key** — create at <https://hardcover.app/account/api> (`hc_pat_...`). Store in machine-local config (`~/.config/chezmoi/chezmoi.toml`, NOT in this repo):

   ```toml
   [variables]
   hardcover_api_key = "hc_pat_..."
   ```

   The script template interpolates `{{ .hardcover_api_key }}`; the env var `HARDCOVER_API_KEY` overrides it. The literal key never touches this repo — `chezmoi.toml` is gitignored by convention (machine-local secrets).

2. **Calibre library** — default `~/Calibre Library` (override: `CALIBRE_LIBRARY` env). Metadata drives the match, so keep ISBN/title clean.

3. **Foliate** — auto-detected from `~/.local/share/com.github.johnfactotum.Foliate/` (native) or the flatpak data dir. No config needed.

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

## Automate (optional)

Systemd timer or cron weekly is enough. Or just run it ad hoc after reading sessions.