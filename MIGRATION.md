# CachyOS Migration Guide — ThinkPad X13 Yoga

This guide covers migrating to a **ThinkPad X13 Yoga Gen 2 (i5-1145G7, 16GB RAM)**
running CachyOS, with a focus on DFIR (Digital Forensics & Incident Response) workflows.

DFIR-heavy tooling (Autopsy, Volatility, Sleuth Kit full suite, Wireshark, etc.)
lives in a **Kali Linux VM** — the host stays lean, fast, and reproducible.

## Recommended Partition Layout (16GB RAM)

ThinkPad X13 Yoga has a 256GB NVMe SSD. Adjust if you have a different size.

| Partition | Size    | Notes |
|-----------|---------|-------|
| /boot/efi | 512MB   | EFI System |
| /         | 80GB    | Root (CachyOS + dev tools + daily apps) |
| /home     | ~160GB  | Projects, disk images, VMs |

> Skip swap — zram handles compression with 16GB RAM.
> If you upgrade the SSD, consider leaving unallocated space for
> future dual-boot or dedicated forensic data partitions.

## Pre-Migration Backup

### Using the backup script
```bash
# Find your USB partition (usually /dev/sda1)
lsblk

# Mount it
sudo mkdir -p /mnt/usb && sudo mount /dev/sda1 /mnt/usb

# Backup everything
./scripts/backup.sh /mnt/usb backup
```

### What this backs up
| Item | Path | Notes |
|------|------|-------|
| Dotfiles | `~/dotfiles` | Also on GitHub |
| Documents | `~/Documents` | |
| Pictures | `~/Pictures` | |
| LibreWolf | `~/.librewolf` | Bookmarks, history, passwords |
| SSH keys | `~/.ssh` | ⚠️ Sensitive |
| GPG keys | `~/.gnupg` | ⚠️ Sensitive |
| Passwords | `~/.password-store` | ⚠️ Sensitive |
| Package list | | `pkglist.txt` + `pkglist-aur.txt` |

### Manual only
- **Bitwarden vault**: Export from web vault as JSON
- **Kali VM disk/images**: If migrating from an existing VM

## Fresh Install Steps

### 1. Install CachyOS
- Download from cachyos.org
- Use recommended partition layout above
- **Enable LUKS encryption** during install
- When the installer asks about kernel variants, pick **linux-cachyos** (default)

### 2. Mount USB & Restore
```bash
sudo mkdir -p /mnt/usb && sudo mount /dev/sda1 /mnt/usb
```

### 3. Clone Dotfiles
```bash
git clone https://github.com/Yushi5058/dotfiles.git
cd dotfiles
./scripts/backup.sh /mnt/usb restore
```

### 4. Run Install Script
```bash
cd dotfiles
chmod +x scripts/install.sh
./scripts/install.sh
```

### 5. Deploy Dotfiles
```bash
cd dotfiles
./scripts/deploy.sh
```

### 6. Enable Services
Services (`ly`, `libvirtd`, `power-profiles-daemon`) are auto-enabled by the install script.
This step is only needed if you skipped the install script or services failed to enable:

```bash
sudo systemctl enable --now ly@tty2
sudo systemctl enable --now libvirtd
sudo systemctl enable --now power-profiles-daemon
```

### 7. Set Up Kali VM
```bash
# Create Kali VM with at least 8GB RAM + 64GB disk
# Download ISO from kali.org
virt-manager
```

## ThinkPad X13 Yoga Gen 2 (i5-1145G7, 16GB) Notes

### CPU / iGPU
- **Intel i5-1145G7** — Tiger Lake UP3, 4C/8T, up to 4.4 GHz
- **iGPU**: Intel Iris Xe (96 EU) — drives the internal display
- Install includes: `intel-media-driver`, `libva-intel-driver`, `vulkan-intel`

### Input Devices
Run `swaymsg -t get_inputs` on first boot to identify device IDs.
Expected identifiers for the X13 Yoga Gen 2:

- **TrackPoint**: `"TPPS/2 IBM TrackPoint"` or similar
- **Touchpad**: `"SYNA"` or `"ELAN"` prefix — X13 Yoga typically uses Synaptics
- **Touchscreen**: `"Wacom"` or `"ELAN"` touchscreen — **X13 Yoga has one!**
- **Stylus**: Wacom AES pen (stored in the garaged silo on the right side)

Update `sway/.config/sway/config` with the correct IDs after install.

Suggested input config for the X13 Yoga:
```
# TrackPoint — enable for scrolling
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

### Display
- **13.3" 16:10 WUXGA (1920×1200)** touchscreen (also available as 2560×1600)
- **Touch + digitizer**: Wacom AES, garaged stylus
- **Scaling**: `scale 1` works well at 1920×1200, or `scale 1.25` at 2560×1600
- **Backlight**: Verify with `ls /sys/class/backlight/`
  - Usually `intel_backlight` — brightnessctl handles it fine
- **Tablet mode**: The screen can fold 360°. Sway doesn't auto-detect this.
  If you want automatic rotation/disabling keyboard in tablet mode, see:
   - `iio-sensor-proxy` (install with: `sudo pacman -S iio-sensor-proxy`)
   - `sway-auto-kb` or a custom udev rule

### Yoga-Specific Features
| Feature | Notes |
|---------|-------|
| 360° hinge | Screen folds flat for tent/tablet/stand modes |
| Wacom AES stylus | Garaged on the right side. Uses Wacom drivers |
| Touchscreen | `Wacom` or `ELAN` touch input |
| Tablet mode switch | Detected via `iio-sensor-proxy` — you may want to bind it |
| Privacy shutter | Physical ThinkShutter on the webcam |

### Audio
Uses SOF (Sound Open Firmware). The install script includes `sof-firmware`.
If volume keys don't work, update the WirePlumber device name.

### Battery
- Device: `BAT0`
- Waybar detects it automatically
- With 16GB RAM, zram setting:

```ini
# systemd/.config/systemd/zram-generator.conf
[zram0]
zram-size = ram / 4
compression-algorithm = zstd
```

### Power Management
```bash
sudo systemctl enable --now power-profiles-daemon
powerprofilesctl set power-saver   # on battery
powerprofilesctl set performance   # plugged in
```

### WiFi / Bluetooth
- **WiFi**: Intel AX201 (WiFi 6, `iwlwifi`) — works out of the box
- **Bluetooth**: Intel integrated, works with `bluez` + `blueman`

### USB-C / Thunderbolt 4
- 2× USB-C (Thunderbolt 4) + 2× USB-A (3.2)
- HDMI 2.0 port
- Headphone jack (3.5mm combo)
- MicroSD card reader
- Smart card reader (optional)
- Drivers: `bolt` for Thunderbolt management (install with: `sudo pacman -S bolt`)

### Keyboard
- 6-row, backlit, spill-resistant
- TrackPoint with 3 physical buttons above the touchpad
- Layout: standard ISO/ANSI (verify yours)

## DFIR-Focused Setup

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
- [ ] Test Wacom stylus — check with `xsetwacom list devices` or `libinput list-devices`
- [ ] Test touchscreen — check with `libinput list-devices`
- [ ] Enable ly (already done by install.sh)
- [ ] Enable libvirtd (already done by install.sh)
- [ ] Spin up Kali VM via virt-manager
- [ ] Enable LUKS encryption (already set during install)
- [ ] Configure `bolt` if using Thunderbolt devices
- [ ] Import SSH keys and GPG keys
- [ ] Test backup: `./scripts/backup.sh /mnt/usb backup`

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
