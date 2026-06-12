# Dotfiles
These dotfiles are managed by: **Gnu Stow**. They say it's a sane
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
_Clone the repo_: 
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
- **Virt**: VirtualBox
- **Browser**: librewolf-bin (AUR)
- **Exts**: uBlock Origin, SponsorBlock, Bitwarden, Auto Tab Discard, Unhook, Voyager, Firefox Color
- **DNS**: NextDNS CLI

### AUR
- librewolf-bin, vscodium-bin, swaylock-effects-git, rose-pine-cursor, maplemono-ttf (Maple Mono)

### Stow Modules
Available packages: `bat btop discord fastfetch fuzzel ghostty git kvantum librewolf mako nvim pipewire ripgrep scripts starship stow sway swaylock systemd tmux vesktop vim waybar wireplumber yazi zathura zsh`


### NextDNS CLI

```bash
sudo nextdns install -config 2f49ca
sudo nextdns activate
nextdns status
```

> If Electron apps show `Temporary failure in name resolution`, ensure the stub resolver:
> ```bash
> sudo rm -f /etc/resolv.conf
> sudo ln -sf /run/systemd/resolve/stub-resolv.conf /etc/resolv.conf
> ```
