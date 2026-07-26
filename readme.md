# Dotfiles

Personal dotfiles managed with **[chezmoi](https://www.chezmoi.io/)**.

- **OS**: Linux (Arch)
- **WM**: Sway
- **DM**: ly
- **Editor**: Neovim
- **Terminal**: Ghostty
- **Font**: Ubuntu (UI) / Maple Mono (terminal)
- **Cursor**: Rose Pine

## Quick Start

### New machine (full setup)
```bash
sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply \
    https://codeberg.org/yushi_61/dotfiles.git
```
This installs chezmoi, clones dotfiles, prompts for machine-specific values (email, displays, GPG key), applies configs, and installs all packages.

### Existing machine (dotfiles only)
```bash
git clone https://codeberg.org/yushi_61/dotfiles.git
cd dotfiles
./scripts/install.sh   # installs chezmoi, clones, applies
```

Or manually:
```bash
chezmoi init ~/dotfiles
chezmoi apply
```

## Package Overview

### Core (pacman)
| Category | Packages |
|----------|----------|
| WM | sway, waybar, mako, swaylock-effects-git |
| Terminal | ghostty |
| Launcher | fuzzel |
| Shell | zsh + starship + zinit |
| Editor | neovim |
| Fonts | Maple Mono (AUR), Ubuntu, Font Awesome |
| Dev | git, go, rust, zig, python, nodejs, lazygit, dbeaver |
| System | ly, earlyoom, zram-generator, pipewire |
| Virt | VirtualBox |
| Browser | librewolf-bin (AUR) |
| DNS | NextDNS CLI |

### AUR
`librewolf-bin`, `vscodium-bin`, `swaylock-effects-git`, `rose-pine-cursor`, `maplemono-ttf`

### LibreWolf Configuration

All prefs are set via `dot_librewolf/librewolf.overrides.cfg` using `defaultPref()` (can be overridden in `about:config`).

| Feature | Pref / Notes |
|---------|-------------|
| Vertical Tabs | `sidebar.verticalTabs = true`. Requires Firefox ≥ 136. Toggle sidebar with Ctrl+B. |
| Session Restore | Restores previous tabs after restart or crash. Tabs load on click (`restore_on_demand`). |
| Ctrl+Tab | Cycles tabs in most-recently-used order (`ctrlTab.recentlyUsedOrder`). |
| Close warning | Warns when closing multiple tabs or quitting (`tabs.warnOnClose*`). |
| Container Tabs | Disabled (`privacy.userContext.enabled = false`). |
| Font | Ubuntu (serif/sans-serif) + Ubuntu Mono |
| WebGL | Always enabled (`webgl.force-enabled`). |
| Hardware Video | VA-API hardware decoding for Intel GPUs. |

**Spell-check dictionaries** — install manually from addons.mozilla.org: [Arabic](https://addons.mozilla.org/search/?q=arabic+dictionary), [French](https://addons.mozilla.org/search/?q=french+dictionary), [German](https://addons.mozilla.org/search/?q=german+dictionary).

### LibreWolf Extensions
| Extension | Purpose / Config |
|-----------|---------|
| uBlock Origin | Ad blocker (config backed up via `ublock-backup.json`) |
| SponsorBlock | Skip YouTube sponsors |
| Bitwarden | Password manager |
| Unhook | Redirect to subs ✓, Live chat ✗, Hide shorts ✓ |
| Voyager | Gemini protocol browser |
| Auto Tab Discard | Memory management |
| Firefox Color | [Rosé Pine Moon theme](https://color.firefox.com/?theme=XQAAAAJeAQAAAAAAAABBqYhm849SCia48_6EGccwS-xMDPr6BEKkYVSt2yMiAsBLvzmxZf3j0v9IRknMzArcpsl645Ge7EzJvXkxnR-IdpUfjuoH0j2fU5z119YfdJkFCZr51wD39X1AG95aQjSf047Gsfg1eLa-yQmEuzaYNrnHf14SvHw9S9ScswXTOZbWwmf1JWZimp73kln7qUWzPieoSAtTvOMSnh-_0rQgIAgRFJJmsMtlxHeL_7_RO1PDjOCPnSpqZVvvdez9JEkZPIodlTKsU6P-62x-rt27JQGm6FBGeeFfDv9hn2AA) |

### Managed Configs
`bat btop discord fastfetch fuzzel ghostty git librewolf mako nvim paru pipewire ripgrep starship sway swaylock systemd tmux vim waybar wireplumber yazi zathura zsh`

## Fresh Install

### Partition Layout (256GB NVMe)
| Partition | Size | Notes |
|-----------|------|-------|
| `/boot/efi` | 512MB | EFI System |
| `/` | 80GB | Root |
| `/home` | ~160GB | Projects, VMs |
| swap | — | zram handles it |

### Migration
Transfer files from the old machine:

```bash
# On old machine — pack & send
./scripts/migrate.sh   # archives Documents, .ssh, .gnupg via croc + 7z

# On new machine — receive
croc <code> --yes --out - | 7z x -si -aoa
```

Then bootstrap with chezmoi:

```bash
# One-liner (recommended) — installs chezmoi, clones, applies
sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply \
    https://codeberg.org/yushi_61/dotfiles.git

# Or clone first, then deploy
git clone https://codeberg.org/yushi_61/dotfiles.git
cd dotfiles
./scripts/install.sh
```

`chezmoi init` will prompt for your email, GPG key, and display names on first run. Package installation runs automatically as a `run_once_` script.

### Post-Install Checklist
- [ ] Update `zram-generator.conf` for 16GB (`ram / 4`)
- [ ] Enable `power-profiles-daemon` and set up profiles
- [ ] Configure TrackPoint / touchpad in Sway
- [ ] Test display scaling (update Waybar font size if needed)
- [ ] Verify brightness keys, volume keys, microphone mute
- [ ] Test Wacom stylus / touchscreen
- [ ] Verify SSH keys (`ssh -T git@github.com`)
- [ ] Verify GPG keys (`gpg --list-secret-keys`)
- [ ] Spin up Kali VM

## Chezmoi Usage

### Daily workflow
```bash
chezmoi add ~/.config/some/file        # Add a new file to management
chezmoi edit ~/.config/some/file        # Edit a managed file
chezmoi diff                            # Review pending changes
chezmoi apply                           # Apply changes to $HOME
chezmoi status                          # Check what's different
chezmoi update                          # Pull & apply latest from remote
```

### Templated files
Some files use chezmoi templates to handle machine-specific differences:

| File | Variable | Prompt |
|------|----------|--------|
| `dot_gitconfig.tmpl` | `email`, `name`, `gpg_key` | Email, name, GPG key ID |
| `dot_config/sway/config.tmpl` | `primary_output`, `secondary_output` | Primary/secondary display names |
| `.chezmoi.toml.tmpl` | All of the above | Asked during `chezmoi init` |

To change values on an existing machine, edit `~/.config/chezmoi/chezmoi.toml` and run `chezmoi apply`.

### Commit changes
```bash
chezmoi cd                              # Enter source directory
git add . && git commit -m "message"    # Commit changes
git push                                # Push to remote
exit                                    # Return to shell
```

### Run scripts
chezmoi runs scripts automatically during `apply`:

| Script | When | What |
|--------|------|------|
| `.chezmoiscripts/run_once_before_bootstrap-chezmoi.sh.tmpl` | First apply | Installs chezmoi if missing |
| `.chezmoiscripts/run_once_after_setup-packages.sh.tmpl` | First apply | Installs packages via pacman/paru |

Scripts are `run_once_` — they execute only once and skip on subsequent `chezmoi apply` calls.

### One-liner on a new machine (full setup)
```bash
sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply \
    https://codeberg.org/yushi_61/dotfiles.git
```
This clones the repo, prompts for template variables (email, displays, etc.), and applies all dotfiles. The `run_once_after_setup-packages.sh` script then installs all packages automatically.

## Hardware Notes — ThinkPad X13 Yoga Gen 2

| Feature | Notes |
|---------|-------|
| CPU | Intel i5-1145G7 (4C/8T, up to 4.4 GHz) |
| GPU | Intel Iris Xe (96 EU) |
| RAM | 16GB (no swap — zram with zstd) |
| Storage | 256GB NVMe |
| Display | 13.3" WUXGA (1920×1200) touch, Wacom AES stylus |
| WiFi/BT | Intel AX201 (WiFi 6), works OOTB |
| Ports | 2× USB-C (TB4), 2× USB-A, HDMI 2.0, 3.5mm, microSD |

### Sway Input Config
```bash
swaymsg -t get_inputs   # find device IDs
```

```text
# TrackPoint
input "TPPS/2 IBM TrackPoint" {
    accel_profile adaptive
    pointer_accel -0.4
    scroll_method on_button_down
    scroll_button 272
}

# Touchpad
input type:touchpad {
    dwt enabled
    tap enabled
    natural_scroll enabled
    pointer_accel 0.2
}

# Touchscreen — disabled by default to avoid accidental input
input type:touch {
    events disabled
}
```

## DFIR Setup

DFIR tooling lives in a **Kali Linux VM** (VirtualBox) — the host stays lean.

### Kali VM Setup
```bash
sudo apt update && sudo apt full-upgrade -y
sudo apt install -y \
    kali-linux-headless kali-tools-forensics \
    kali-tools-reverse-engineering kali-tools-web \
    kali-tools-password-recovery kali-tools-exploitation \
    kali-tools-crypto-stego kali-tools-information-gathering \
    kali-tools-vulnerability

sudo apt install -y \
    burpsuite bloodhound impacket-scripts responder wireshark \
    gdb pwntools ropper seclists gobuster ffuf \
    jq exiftool steghide binwalk p7zip-full

# Guest Additions
sudo mount /dev/cdrom /mnt
sudo /mnt/VBoxLinuxAdditions.run
sudo usermod -aG vboxsf kali
```

### Snapshot Workflow
```bash
VBoxManage snapshot kali-vm take "Clean Install"
VBoxManage snapshot kali-vm take "Before CTF-xyz"
VBoxManage snapshot kali-vm restore "Clean Install"
```

### Mount shared folder
```bash
sudo mkdir -p /mnt/cases && sudo mount -t vboxsf cases /mnt/cases
```

## Troubleshooting

### NextDNS — stub resolver
```bash
sudo nextdns install -config 2f49ca
sudo nextdns activate
nextdns status
```

> If Electron apps show `Temporary failure in name resolution`:
> ```bash
> sudo rm -f /etc/resolv.conf
> sudo ln -sf /run/systemd/resolve/stub-resolv.conf /etc/resolv.conf
> ```

### Impala — WiFi backend
```bash
sudo nvim /etc/NetworkManager/conf.d/wifi_backend.conf
```

```ini
[device]
wifi.backend=iwd
```

```bash
sudo systemctl restart iwd NetworkManager
```
