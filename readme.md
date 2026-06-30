# Dotfiles

Personal dotfiles managed with **GNU Stow**.

- **OS**: Linux (Arch)
- **WM**: Sway
- **DM**: ly
- **Editor**: Neovim
- **Terminal**: Ghostty
- **Font**: Ubuntu (UI) / Maple Mono (terminal)
- **Cursor**: Rose Pine

## Quick Start

```bash
git clone https://codeberg.org/yushi_61/dotfiles.git
cd dotfiles
./scripts/install.sh   # packages, services, stow
```

Or just deploy dotfiles after cloning:

```bash
restow-all   # zsh alias for stow --restow */
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

### Stow Modules
`bat btop discord fastfetch fuzzel ghostty git kvantum librewolf mako nvim pipewire ripgrep scripts starship stow sway swaylock systemd tmux vesktop vim waybar wireplumber yazi zathura zsh`

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

Then clone dotfiles, run the install script, and enable services:

```bash
git clone https://codeberg.org/yushi_61/dotfiles.git
cd dotfiles
chmod +x scripts/install.sh && ./scripts/install.sh
systemctl enable --now ly@tty2 power-profiles-daemon
```

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
