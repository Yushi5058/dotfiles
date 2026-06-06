# CachyOS DFIR Migration Guide

This guide covers migrating to a **ThinkPad X1 (16GB RAM)** running CachyOS,
with a focus on DFIR (Digital Forensics & Incident Response) workflows.

DFIR-heavy tooling (Autopsy, Volatility, Sleuth Kit full suite, Wireshark, etc.)
lives in a **Kali Linux VM** — the host stays lean, fast, and reproducible.

## Recommended Partition Layout (16GB RAM)

ThinkPad X1 SSDs range from 256GB–1TB. Adjust accordingly.

| Partition | Size    | Notes |
|-----------|---------|-------|
| /boot/efi | 512MB   | EFI System |
| /         | 80GB    | Root (CachyOS + dev tools + daily apps) |
| /home     | Rest    | Projects, disk images, memory dumps, VM disk images |

> Skip swap — zram handles compression with 16GB RAM.
> If you have a large SSD (>512GB), consider leaving unallocated space for
> future dual-boot or dedicated forensic data partitions.

## Pre-Migration Backup

### What to Backup Manually
1. **Dotfiles**: Already in GitHub
2. **Documents**: `~/Documents`
3. **Pictures**: `~/Pictures`
4. **SSH keys**: `~/.ssh/` (⚠️ Keep private, don't share)
5. **Password store**: `~/.password-store` (⚠️ Sensitive)
6. **LibreWolf profile**: `~/.librewolf/` (Bookmarks, cookies, logins)
7. **Bitwarden vault**: Export from web vault as JSON
8. **Kali VM disk/images**: If migrating from an existing VM

### Commands
```bash
# Backup to external drive
mkdir /media/backup
cp -r ~/Documents /media/backup/
cp -r ~/Pictures /media/backup/
cp -r ~/.librewolf /media/backup/
# Export Bitwarden: Web Vault → Settings → Export → JSON
```

### Do NOT Backup
- `~/.cache/` (can be regenerated)
- `~/Downloads/` (large, can redownload)

## Fresh Install Steps

### 1. Install CachyOS
- Download from cachyos.org
- Use recommended partition layout above
- **Enable LUKS encryption** during install (DFIR work may involve handling
  sensitive case data — encrypted at rest by default)

### 2. Clone Dotfiles
```bash
git clone https://github.com/Yushi5058/dotfiles.git
cd dotfiles
stow -v -t ~ bat btop discord fastfetch ghostty fuzzel mako nvim pipewire ripgrep scripts starship stow sway swaylock systemd tmux vim waybar wireplumber yazi zathura zsh
```

### 3. Run Install Script
```bash
cd dotfiles
chmod +x scripts/install.sh
./scripts/install.sh
```

### 4. Restore Browser Profile
```bash
cp -r /media/backup/.librewolf ~/.librewolf
```

### 5. Login
- Bitwarden: `bw login yushi_61@proton.me` then `bw unlock`
- SSH: Add keys back to `~/.ssh/`

### 6. Enable Services
```bash
# Display manager (replaces sddm)
sudo systemctl enable --now ly

# Virtualization (virt-manager already installed via install script)
sudo systemctl enable --now libvirtd
```

### 7. Set Up Kali VM
```bash
# Create Kali VM with at least 8GB RAM + 64GB disk
# Download ISO from kali.org
virt-manager
```

## ThinkPad X1 (16GB) Notes

### Input Devices
Run `swaymsg -t get_inputs` on first boot to identify new device IDs.
The TrackPoint identifier will differ from the current Elantech one.

Update `sway/.config/sway/config` with the correct IDs:
- **TrackPoint**: likely `"TPPS/2 IBM TrackPoint"` or `"Synaptics TM3576-001"`
- **Touchpad**: likely `"SYNA*"` or `"ELAN*"` — think about whether you want
  palm detection (disable TrackPoint while typing) or both active
- **Touchscreen**: most X1 models don't have one

Suggested TrackPoint tuning for Sway:
```
input "TPPS/2 IBM TrackPoint" {
    accel_profile custom
    pointer_accel -0.4
    scroll_method on_button_down
    scroll_button 272   # middle mouse button
}
```

### Display Scaling
X1 Carbon uses a 14" 16:10 panel. Common resolutions:

| Resolution | Scaling | Notes |
|------------|---------|-------|
| 1920×1200  | `scale 1` | Sharp without scaling; good for terminal-heavy DFIR work |
| 2560×1600  | `scale 1.25` or `1.5` | Crisp, more screen real estate |
| 3840×2400  | `scale 2` | OLED — excellent for image analysis in forensics |

Scaling affects Waybar, Fuzzel, Ghostty font sizes — adjust accordingly.
For DFIR work (reading hex dumps, logs, timelines), **1920×1200 or 2560×1600**
is often more practical than 4K (tiny text).

### Backlight
Newer X1 models use `intel_backlight`.
Verify: `ls /sys/class/backlight/`
`brightnessctl` bindings work either way.

### Audio
ThinkPad X1 uses SOF (Sound Open Firmware). The install script includes
`sof-firmware`. If volume keys don't work after install, update the WirePlumber
device name in `sway/.config/sway/config`.

### Battery
- Device: `BAT0`
- Waybar module detects it automatically
- With 16GB RAM, zram is plenty — set it conservatively:

```ini
# systemd/.config/systemd/zram-generator.conf
[zram0]
zram-size = ram / 4
compression-algorithm = zstd
```

### Power Management
Enable battery-optimized profiles for the X1:
```bash
sudo systemctl enable --now power-profiles-daemon
powerprofilesctl set power-saver   # on battery
powerprofilesctl set performance   # plugged in (for DFIR processing)
```

### WiFi
Intel WiFi (`iwlwifi`) works out of the box on all X1 models.

### Fingerprint Reader
ThinkPad X1 has a fingerprint reader. Set it up if desired:
```bash
fprintd-enroll
# Then configure for sudo:
sudo pam-auth-update --enable fprintd
```

### Thunderbolt / USB-C
X1 uses USB-C/Thunderbolt for all external connections. Test your forensic
write-blocker or USB device adapters. You may need `bolt` (Thunderbolt manager):
```bash
sudo pacman -S bolt
```

## DFIR-Focused Setup

### Host Tools (on CachyOS)
These live natively for quick analysis without spinning up the VM:

```bash
# File analysis
sudo pacman -S xxd hexdump file tree

# Disk/image mounting
sudo pacman -S fuse2 fuse3 libewf afflib sleuthkit

# Memory analysis light
sudo pacman -S volatility3

# Network
sudo pacman -S nmap netcat-openbsd tcpdump

# File carving / recovery (light)
sudo pacman -S testdisk foremost

# Metadata
sudo pacman -S perl-image-exiftool

# Hashing
sudo pacman -S rhash xxhash

# Archiving / compression forensics
sudo pacman -S p7zip unrar unzip gzip bzip2 xz zstd

# Log analysis
sudo pacman -S lnav

# Timeline / forensic file browsing
# (use yazi / ncdu for exploring disk images)
```

### Kali VM Configuration
All heavy DFIR tools belong here:

```bash
# Recommended Kali packages
sudo apt install kali-tools-forensics kali-tools-reverse-engineering \
    kali-tools-responder autopsys plaso dfir-okta
```

Give the VM:
- **8GB RAM** (half your host)
- **4+ CPU cores**
- **64GB+ disk** (on a fast NVMe location)
- **Bridged or host-only networking** depending on case needs

### Storage Tips for DFIR
- Keep case disk images on the host SSD for fast VM access
- Use `qemu-img` with `qcow2` for the VM disk (compression, snapshots)
- Create a dedicated `~/cases/` directory for case data
- Consider an external NVMe enclosure for evidence drives

### Sway Workspace Layout for DFIR
Suggest re-mapping workspaces for forensic workflow:

| Workspace | Purpose |
|-----------|---------|
| 1         | Terminal (shell, hex dump, CLI tools) |
| 2         | Browser (research, threat intel) |
| 3         | Kali VM (full screen) |
| 4         | Notes / Obsidian (case notes) |
| 5         | File manager / timeline viewer |

## Post-Install Checklist
- [ ] Update `zram-generator.conf` for 16GB (`ram / 4`)
- [ ] Enable `power-profiles-daemon` and set up profiles
- [ ] Configure TrackPoint / touchpad in Sway
- [ ] Test display scaling (update Waybar font size if needed)
- [ ] Verify brightness keys, volume keys, microphone mute
- [ ] Set up `fprintd` if using fingerprint reader
- [ ] Enable ly: `sudo systemctl enable --now ly`
- [ ] Enable libvirtd: `sudo systemctl enable --now libvirtd`
- [ ] Spin up Kali VM via virt-manager
- [ ] Enable LUKS encryption (already set during install)
- [ ] Configure `bolt` if using Thunderbolt devices
- [ ] Import SSH keys and GPG keys
- [ ] Test backup script: `./scripts/backup.sh`

### Font & Cursor Reminders
```bash
# List available cursor themes
ls /usr/share/icons/

# Set cursor theme (in sway config exec_always block)
gsettings set org.gnome.desktop.interface cursor-theme 'BreezeX-RosePine-Linux'

# Set interface font
gsettings set org.gnome.desktop.interface font-name 'Ubuntu 11'

# Terminal font is set in ghostty config: font-family = Maple Mono
```
