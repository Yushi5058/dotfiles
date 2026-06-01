# CachyOS Migration Notes

## When to Migrate
- Current root: 46.9GB / 60GB (78% full)
- Consider migrating when root hits ~85%

## Recommended Partition Layout (8GB RAM)

| Partition | Size | Notes |
|-----------|------|-------|
| /boot/efi | 512MB | EFI System |
| / | 80GB | Root (CachyOS + apps) |
| /home | Rest (~100GB) | Files, CTF tools, projects |

> Skip swap, use zram (already configured in systemd/)

## Pre-Migration Backup

### What to Backup Manually
1. **Dotfiles**: Already in GitHub
2. **Documents**: `~/Documents`
3. **Pictures**: `~/Pictures`
4. **SSH keys**: `~/.ssh/` (⚠️ Keep private, don't share)
5. **Password store**: `~/.password-store` (⚠️ Sensitive)
6. **LibreWolf profile**: `~/.librewolf/` (Bookmarks, cookies, logins)
7. **Bitwarden vault**: Export from web vault as JSON

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
- `~/.local/share/Steam/` (can redownload)

## Fresh Install Steps

### 1. Install CachyOS
- Download from cachyos.org
- Use recommended partition layout above

### 2. Clone Dotfiles
```bash
git clone https://github.com/Yushi5058/dotfiles.git
cd dotfiles
stow -v -t ~ bat btop ghostty fuzzel mako nvim pipewire ripgrep scripts starship stow sway swaylock systemd tmux vim waybar wireplumber yazi zathura zsh librewolf
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

## Post-Install Checklist
- [ ] Set up zram: `sudo systemctl enable --now systemd-zram-setup@zram0`
- [ ] Configure LibreWolf with `librewolf.overrides.cfg`
- [ ] Test waybar, sway, mako
- [ ] Install AUR packages: `librewolf`, `ghostty`, `vesktop`

## ThinkPad X1 Notes

### Input Devices
Run `swaymsg -t get_inputs` on first boot to identify new device IDs.
The TrackPoint identifier will differ from the current Elantech one.

Update `sway/.config/sway/config` with the correct IDs:
- TrackPoint: likely `"TPPS/2 IBM TrackPoint"` or `"Synaptics TM3576-001"`
- Touchpad: likely `"SYNA*"` or `"ELAN*"`
- Touchscreen: only if your X1 model has one (most don't)

### Display Scaling
X1 Carbon uses a 14" 16:10 panel. Common resolutions:
- **1920x1200**: `output eDP-1 scale 1` (no scaling needed)
- **2560x1600**: `output eDP-1 scale 1.25` or `1.5`
- **3840x2400 (OLED)**: `output eDP-1 scale 2`

Scaling affects Waybar, Fuzzel, Ghostty font sizes — adjust accordingly.

### Backlight
Newer X1 models may use `intel_backlight` instead of `acpi_video0`.
Verify with: `ls /sys/class/backlight/`
The `brightnessctl` bindings should work either way.

### Audio
ThinkPad X1 uses SOF (Sound Open Firmware).
Ensure `sof-firmware` is installed for audio to work.
Internal audio device name may change — update `wpctl` commands in Sway config if volume keys stop working.

### Battery
Usually `BAT0`. Waybar battery module detects it automatically.
If the X1 has >8GB RAM, update `zram-generator.conf`:
- `zram-size = ram / 2` → `zram-size = ram / 3` for 16GB, or `ram / 4` for 32GB

### General
- **WiFi**: Intel WiFi works well with `iwlwifi` (in-kernel)
- **Fingerprint**: Configurable with `fprintd` if desired
- **Power profiles**: Use `power-profiles-daemon` or `tlp` for battery optimization

## Optimizations for i5 7th Gen / 8GB RAM
- Use zram for swap compression
- LibreWolf: Limit processes to 2
- Keep Discord/WhatsApp on phone
- Use `zsh` with `starship` prompt