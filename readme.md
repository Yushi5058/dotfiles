# Dotfiles

Personal dotfiles managed with **[chezmoi](https://www.chezmoi.io/)**.

- **OS**: Arch Linux (CachyOS)
- **WM**: Sway · **DM**: ly · **Editor**: Neovim · **Terminal**: Ghostty
- **Bar**: eww (Nord palette, seconds in clock)
- **Launcher**: fuzzel (`$mod+d`, fzf matching) · wofi fallback (`$mod+Shift+d`)
- **Font**: Ubuntu (UI) / Maple Mono (terminal) · **Cursor**: Nordzy · **Theme**: Nord
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
| WM | sway, eww, mako, swaylock, fuzzel (launcher) + wofi (fallback) |
| System | ly, earlyoom, zram-generator, pipewire, tlp, ufw, bluez/blueman |
| Dev | git, go, rust, zig, python, nodejs, lazygit, neovim (Antigravity IDE fallback), dbeaver |
| Shell | zsh + starship + zinit |
| Terminal | ghostty, bat, btop, ripgrep, yazi, zathura |
| Browser | floorp-bin |
| Virt | qemu-full + virt-manager + libvirt + swtpm (KVM) — `kali-vbox` (DFIR) + `win11` (malware lab); VMware Workstation (coursework) |
| Other AUR | rustdesk, gearlever |

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
- [Floorp](docs/floorp.md) — prefs (profile `user.js`), extensions
- [NextDNS](docs/nextdns.md) — systemd-resolved DoT, no CLI daemon
