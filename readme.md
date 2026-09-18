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
| System | ly, earlyoom, zram-generator, pipewire, tlp, ufw |
| Power | TLP (power-profiles-daemon masked — conflicts with TLP) |
| Bluetooth | bluez, bluez-utils, blueman (bluetooth.service enabled) |
| Virt | virtualbox, virtualbox-host-dkms, virtualbox-ext-oracle (AUR) |
| Browser | floorp-bin (AUR) |
| DNS | NextDNS CLI |

### AUR
`floorp-bin`, `vscodium-bin`, `swaylock-effects-git`, `rose-pine-cursor`, `maplemono-ttf`, `virtualbox-ext-oracle`

### Floorp Configuration

All prefs are set via `dot_config/floorp/floorp/floorp.overrides.cfg` using `defaultPref()` / `pref()` (can be overridden in `about:config`).

| Feature | Pref / Notes |
|---------|-------------|
| Vertical Tabs | `sidebar.verticalTabs = true`. Requires Firefox ≥ 136. Toggle sidebar with Ctrl+B. |
| Session Restore | Restores previous tabs after restart or crash. Tabs load on click (`restore_on_demand`). |
| Ctrl+Tab | Cycles tabs in most-recently-used order (`ctrlTab.recentlyUsedOrder`). |
| Close warning | Warns when closing multiple tabs or quitting (`tabs.warnOnClose*`). |
| Container Tabs | Disabled (`privacy.userContext.enabled = false`). |
| Font | Ubuntu (serif/sans-serif) + Ubuntu Mono |
| WebGL | Always enabled (`webgl.force-enabled`, `webgl.enable-webgl2`). |
| Hardware Video | VA-API hardware decoding for Intel GPUs (AV1 forced off — Tiger Lake has no hw AV1). |
| Telemetry | Disabled (`toolkit.telemetry.enabled = false`). |

**Spell-check dictionaries** — install manually from addons.mozilla.org: [Arabic](https://addons.mozilla.org/search/?q=arabic+dictionary), [French](https://addons.mozilla.org/search/?q=french+dictionary), [German](https://addons.mozilla.org/search/?q=german+dictionary).

### Floorp Extensions

All extensions installed via Floorp's extension manager or manually from AMO. Configs stored in `extensions.json` / `storage.js` in profile.

| Extension | Purpose / Config |
|-----------|------------------|
| uBlock Origin | Ad/tracker blocker. Filters: EasyList, EasyPrivacy, Peter Lowe, uBlock filters, Annoyances. Custom: `||googletagmanager.com^`, `||google-analytics.com^`. No cosmetic filtering exceptions. |
| SponsorBlock | Skip YouTube sponsors, intros, outros, interactions. Auto-skip enabled. Categories: sponsor, intro, outro, selfpromo, interaction, music_offtopic, preview. Keyboard: `→` skip, `←` back. |
| Bitwarden | Password manager. Vault timeout: never (lock with system). Auto-fill on page load. URI matching: base domain. TOTP auto-copy. Biometric unlock if available. |
| Unhook | YouTube cleanup. Hide: shorts, related videos, comments, live chat, playlists, shelf, "watch next", "more from", "people also watched". Force theater mode. Disable autoplay. |
| Auto Tab Discard | Memory management. Discard after 10 min inactive. Whitelist: pinned tabs, tabs playing audio, tabs with form input, `*://mail.*`, `*://calendar.*`, `*://github.com/*`. Restore on click. |
| Gemini Voyager | Google Gemini sidebar. Floating panel (Ctrl+Shift+Y). Auto-hide on blur. Theme: system. Context menu: "Send to Gemini". Streaming responses. |
| Firefox Color | Browser theming. Theme: Rose Pine (from [rose-pine/firefox](https://github.com/rose-pine/firefox)). Colors: base `#191724`, surface `#1f1d2e`, overlay `#26233a`, muted `#6e6a86`, subtle `#908caa`, text `#e0def4`, love `#eb6f92`, gold `#f6c177`, rose `#ebbcba`, pine `#31748f`, foam `#9ccfd8`, iris `#c4a7e7`. Applied to toolbar, tabs, sidebar, new tab. |

### Managed Configs
`bat btop discord fastfetch fuzzel ghostty git floorp mako nvim paru pipewire ripgrep starship sway swaylock systemd tmux vim waybar wireplumber yazi zathura zsh`

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
- [ ] Verify TLP active + `power-profiles-daemon` masked (`systemctl is-active tlp`)
- [ ] Enable bluetooth if needed: `sudo systemctl enable --now bluetooth`
- [ ] Verify `ufw` is active (`sudo ufw status`)
- [ ] Configure TrackPoint / touchpad in Sway
- [ ] Test display scaling (update Waybar font size if needed)
- [ ] Verify brightness keys, volume keys, microphone mute
- [ ] Test Wacom stylus / touchscreen
- [ ] Verify SSH keys (`ssh -T git@github.com`)
- [ ] Verify GPG keys (`gpg --list-secret-keys`)
- [ ] Add user to `vboxusers` group: `sudo gpasswd -a $USER vboxusers` (re-login)
- [ ] Spin up Kali VM (VirtualBox)
- [ ] Spin up Windows 11 VM (VirtualBox)

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

> **Note**: `run_once_after_setup-packages.sh` needs an **interactive sudo** prompt (requires a TTY). If the first `chezmoi apply` is non-interactive it fails on the sudo step — just re-run `chezmoi apply` from a terminal.

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

DFIR tooling lives in a **Kali Linux VM** (VirtualBox) — the host stays lean. Windows 11 VM also runs in VirtualBox.

### Kali VM Setup (VirtualBox)
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

# VirtualBox Guest Additions (display, clipboard, shared folders, seamless mode)
sudo apt install -y virtualbox-guest-dkms virtualbox-guest-utils virtualbox-guest-x11
sudo systemctl enable --now vboxservice
```

### Windows 11 VM (VirtualBox)
```bash
# On host: install VirtualBox + Extension Pack
sudo pacman -S virtualbox virtualbox-host-dkms virtualbox-ext-oracle
sudo gpasswd -a $USER vboxusers
# Reboot or: newgrp vboxusers

# Windows 11 ISO → new VM: 4 vCPU, 8GB RAM, 64GB+ VDI, EFI, TPM 2.0 enabled
# Install VirtIO drivers for network/disk during Windows setup (from fedorapeople.org)
# Install VirtualBox Guest Additions inside Windows for clipboard, shared folders, 3D accel
```

### Snapshot Workflow (VirtualBox)
```bash
# Kali
VBoxManage snapshot kali-vm take "Clean Install"
VBoxManage snapshot kali-vm take "Before CTF-xyz"
VBoxManage snapshot kali-vm restore "Clean Install"

# Windows 11
VBoxManage snapshot win11-vm take "Clean Install"
VBoxManage snapshot win11-vm take "Before Engagement"
VBoxManage snapshot win11-vm restore "Clean Install"
```

### Mount shared folder (VirtualBox)
```bash
# On host: VBoxManage sharedfolder add kali-vm --name cases --hostpath ~/Cases --automount
# In Kali VM:
sudo mkdir -p /mnt/cases
sudo mount -t vboxsf cases /mnt/cases
# Auto-mount at boot: add to /etc/fstab
# cases  /mnt/cases  vboxsf  defaults,uid=1000,gid=1000  0  0
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
