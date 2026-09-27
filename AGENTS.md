# AGENTS.md

## Project overview

Personal dotfiles managed with **chezmoi**. Repo mirrors codeberg → github on every push.

- Main remote: `codeberg` (`git@codeberg.org:yushi_61/dotfiles.git`)
- Mirror remote: `github` (`git@github.com:Yushi5058/dotfiles.git`)
- Source dir: `~/local/share/chezmoi` (chezmoi source of truth, target `$HOME`)

## Commands

```bash
chezmoi apply --dry-run --exclude=scripts   # verify changes without touching $HOME
chezmoi apply                               # apply managed files to $HOME
chezmoi update                              # pull & apply from remote
bash -n <script.sh>                         # syntax-check any script before commit
```

Package sync is automatic via `run_once_after_setup-packages.sh` (idempotent — skips already-installed packages, needs interactive sudo on first run).

## Conventions

- `dot_<path>` = source maps to `~/.<path>` (e.g. `dot_config/` → `~/.config/`); `dot_etc/` → `/etc` (needs `sudo chezmoi apply`).
- `*.tmpl` = templated files (`dot_gitconfig.tmpl`, `dot_config/sway/config.tmpl`, `.chezmoi.toml.tmpl`) — machine vars: email, gpg_key, displays.
- `.chezmoiscripts/run_once_*` = one-shot scripts, run during apply.
- Package lists `dot_config/packages/base.txt` (pacman) + `aur.txt` (AUR): **alphabetical, one per line, no dupes**. After edits, verify `pacman -Qqm` foreign count matches aur.txt entries.
- `docs/` = detailed docs (floorp, nextdns, dfir, hardware, fresh-install). README stays a concise overview — move detail to docs/, never bloat README.
- `dot_config/opencode/AGENTS.md` = opencode **global** behavior (caveman mode) — chezmoi-managed, not repo instructions.

## Commit rules

- Conventional Commits (`feat:` `fix:` `chore:` `docs:`), subject ≤ ~70 chars, only body when "why" isn't obvious.
- Commits are GPG-signed (`gpgsign` on).
- Push once: `git push codeberg main` (dual pushurl mirrors to github). `git mirror` alias does the same.
- Never `force-push` external mirrors unless explicitly asked.

## Security

- **No secrets in this repo.** Never commit: `.ssh/`, `.gnupg/`, machine-local `~/.config/chezmoi/chezmoi.toml` (holds gpg key id + email).
- `.ssh`/.gnupg transfer between machines happens via `scripts/migrate.sh` (croc + 7z), not the repo.
- Kill-switches: any file in `.chezmoiignore` is deliberately not managed — don't re-add without asking.