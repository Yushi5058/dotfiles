# Dotfiles

Personal dotfiles managed with **[chezmoi](https://www.chezmoi.io/)**.

- **OS**: Arch Linux (CachyOS)
- **WM**: Sway · **DM**: ly · **Editor**: Neovim · **Terminal**: Ghostty
- **Font**: Ubuntu (UI) / Maple Mono (terminal) · **Cursor**: Rose Pine
- **Browser**: Floorp · **DNS**: NextDNS (systemd-resolved DoT)

## Quick Start

```bash
# New machine — installs chezmoi, clones, prompts template vars, applies, installs packages
sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply \
    https://codeberg.org/yushi_61/dotfiles.git

# Existing machine, dotfiles only
git clone https://codeberg.org/yushi_61/dotfiles.git
cd dotfiles && ./scripts/install.sh
```

## Repos

Main remote is **codeberg**, mirrored to **github** on every push.

| Remote | URL |
|--------|-----|
| `codeberg` (main) | `git@codeberg.org:yushi_61/dotfiles.git` |
| `github` (mirror) | `git@github.com:Yushi5058/dotfiles.git` |

Shorthands (global gitconfig): `cb:repo` → codeberg, `gh:repo` → github. Push once:

```bash
git push codeberg main    # → codeberg + github mirror
# or: git mirror
```

## Package Overview

| Category | Packages |
|----------|----------|
| WM | sway, waybar, mako, swaylock-effects-git |
| System | ly, earlyoom, zram-generator, pipewire, tlp, ufw, bluez/blueman |
| Dev | git, go, rust, zig, python, nodejs, lazygit, neovim, dbeaver |
| Shell | zsh + starship + zinit |
| Terminal | ghostty, fuzzel, bat, btop, ripgrep, yazi, zathura |
| Browser | floorp-bin |
| Books | calibre, foliate, hardcover (reading progress sync) |
| Virt | virtualbox + host-dkms + ext-oracle (AUR) |
| Other AUR | vscodium-bin, rustdesk, slack-desktop-wayland, gearlever |

Full lists: `dot_config/packages/base.txt` (pacman) and `aur.txt` (AUR). DNS = NextDNS via systemd-resolved DoT (no extra package, see [NextDNS docs](docs/nextdns.md)).

## Chezmoi

```bash
chezmoi add ~/.config/some/file   # manage a file
chezmoi diff / edit / apply       # review / edit / apply changes
chezmoi update                    # pull & apply from remote
chezmoi cd                        # enter source dir (commit/push from here)
```

Templated files (`machine data: email, gpg key, displays`): `dot_gitconfig.tmpl`,
`dot_config/sway/config.tmpl`, `.chezmoi.toml.tmpl`.

## Documentation

- [Fresh install](docs/fresh-install.md) — partitions, migration, bootstrap, checklist
- [Hardware](docs/hardware.md) — ThinkPad X13 Yoga Gen 2, Sway input config
- [Hardcover](docs/hardcover.md) — reading progress sync (Foliate / Moon+ → Hardcover)
- [Floorp](docs/floorp.md) — prefs (profile `user.js`), extensions
- [NextDNS](docs/nextdns.md) — systemd-resolved DoT, no CLI daemon
- [DFIR](docs/dfir.md) — Kali / Windows 11 VMs, snapshots