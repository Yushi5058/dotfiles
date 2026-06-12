# Dotfiles
These dotfiles are managed by : **Gnu Stow**. They say it's a sane
configuration.


## Overview

- OS : Linux
- Distro : Arch
- WM : Sway
- DM : ly
- Code Editor : Neovim 
- Terminal : Ghostty
- Font : Ubuntu (UI) / Maple Mono (terminal)
- Cursor : Rose Pine

## Instructions
_Clone the repo_ : 
`$ git clone https://codeberg.org/yushi_61/dotfiles.git`

_Use restow-all zsh function_: 
`$ restow-all`

You're good to go!


## Package Overview

### Core (pacman)
- **WM**: sway, waybar, mako, swaylock-effects-git
- **Terminal**: ghostty
- **Launcher**: fuzzel
- **Shell**: zsh + starship + zinit
- **Editor**: neovim
- **Fonts**: Maple Mono (AUR), Ubuntu, Font Awesome (waybar)
- **Dev**: git, go, rust, zig, python, nodejs, lazygit, dbeaver
- **System**: ly, earlyoom, zram-generator, pipewire
- **Virt**: virt-manager, libvirt, qemu-desktop
- **Browser**: librewolf-bin (AUR)
- **Exts**: uBlock Origin, SponsorBlock, Bitwarden, Auto Tab Discard, Unhook, Voyager, Firefox Color
- **DNS**: NextDNS via systemd-resolved

### AUR
- librewolf-bin, vscodium-bin, swaylock-effects-git, rose-pine-cursor, maplemono-ttf (Maple Mono)

### Stow Modules
Available packages: `bat btop discord fastfetch fuzzel ghostty git kvantum librewolf mako nvim pipewire ripgrep scripts starship stow sway swaylock systemd tmux vesktop vim waybar wireplumber yazi zathura zsh`

### ⚠️ Troubleshooting: NextDNS / systemd-resolved Breakage

If Electron apps (**Discord**, **Opencode**, VS Code) fail to launch with a `Temporary failure in name resolution` error, it means the legacy glibc resolver cannot communicate with `systemd-resolved`. 

**The Fix:** Ensure `/etc/resolv.conf` is properly symlinked to the systemd stub resolver.

```bash
# Remove the broken stub/static file
sudo rm -f /etc/resolv.conf

# Link it to systemd-resolved's local stub
sudo ln -sf /run/systemd/resolve/stub-resolv.conf /etc/resolv.conf

# Restart the service and flush caches
sudo systemctl restart systemd-resolved
sudo resolvectl flush-caches

_Note:_ Things might be all over the place. So maybe is it insane in the end?

### NextDNS Setup

Configure NextDNS via systemd-resolved with your config URL:

```bash
# Replace <config-id> with your NextDNS config ID
sudo resolvectl dns eth0 45.90.28.0 45.90.30.0
sudo resolvectl domain eth0 ~.
sudo resolvectl dnsoverhttps eth0 https://<config-id>.dns.nextdns.io
sudo systemctl restart systemd-resolved
```

