# Fresh Install

## Partition Layout (256GB NVMe)

| Partition | Size | Notes |
|-----------|------|-------|
| `/boot/efi` | 512MB | EFI System |
| `/` | 80GB | Root |
| `/home` | ~160GB | Projects, VMs |
| swap | — | zram handles it |

## Migration

```bash
# Old machine — pack & send
./scripts/migrate.sh   # archives Documents, .ssh, .gnupg via croc + 7z

# New machine — receive
croc <code> --yes --out - | 7z x -si -aoa
```

## Bootstrap

```bash
# One-liner: installs chezmoi, clones, prompts template vars, applies
sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply \
    https://codeberg.org/yushi_61/dotfiles.git

# Or clone first
git clone https://codeberg.org/yushi_61/dotfiles.git
cd dotfiles
./scripts/install.sh
```

`chezmoi init` prompts for email, GPG key, display names. Package install runs as `run_once_after_setup-packages.sh` (needs interactive sudo — re-run from a terminal if it fails on the sudo step).

## Post-Install Checklist

- [ ] Update `zram-generator.conf` for 16GB (`ram / 4`)
- [ ] Verify TLP active + `power-profiles-daemon` masked (`systemctl is-active tlp`)
- [ ] Enable bluetooth: `sudo systemctl enable --now bluetooth`
- [ ] Verify `ufw` active (`sudo ufw status`)
- [ ] Configure TrackPoint / touchpad in Sway
- [ ] Test display scaling (Waybar font size)
- [ ] Verify brightness/volume/mic keys
- [ ] Test Wacom stylus / touchscreen
- [ ] Verify SSH keys (`ssh -T git@github.com`)
- [ ] Verify GPG keys (`gpg --list-secret-keys`)
- [ ] `sudo gpasswd -a $USER vboxusers` (re-login)
- [ ] Add NextDNS resolvers (see [docs/nextdns.md](nextdns.md))
- [ ] Spin up Kali + Windows 11 VMs (see [docs/dfir.md](dfir.md))