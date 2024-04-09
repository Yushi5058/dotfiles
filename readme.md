# Dotfiles

Managed with [chezmoi](https://www.chezmoi.io/) and powered with [catppuccin](https://github.com/catppuccin/).

## Overview

- _Shell_ : Zsh
- _Terminal Emulator_ : [Wezterm](https://github.com/wez/wezterm)
- _Menu Launcher_ : [Rofi](https://github.com/davatorium/rofi)
- _Window Manager_ : [Sway-wm](https://github.com/swaywm/)
- _Status Bar_ : [Waybar](https://github.com/Alexays/Waybar/)
- _Powerbutton Menu_ : [Wlogout](https://github.com/ArtsyMacaw/wlogout)
- _Shell plugin manager_ : [Zap](https://github.com/zap-zsh/zap) + [Starship](https://starship.rs/)
- _Notification daemon_ : [Mako](https://github.com/emersion/mako)
- _Code Text Editor_ : [Neovim](https://github.com/neovim/neovim)
- _Code Font_ : [Maple](https://github.com/subframe7536/Maple-font/)
- _Regular Font_ : [Cantarell](https://fonts.google.com/specimen/Cantarell)
- _Icons Font_ : [FontAwesome](https://github.com/FortAwesome/Font-Awesome)
- _GTK Theme_ : Catppuccin Standard Blue Dark
- _System Icons_ : Tela Blue Dark
- _System Cursor_ : Catppuccin Blue
- _Login Manager_ : [Ly](https://github.com/fairyglade/ly)
- _File Manager_ : Thunar
- _Browser_ : [Firefox](https://www.mozilla.org/en-US/firefox/new/)

## Notice

- `chsh -s /usr/bin/zsh` to make zsh the default shell.
- The packages to install are in the packages.txt, separated
  by type : AUR or Pacman.
- `$ nvim --headless "+Lazy!sync" +qa` to sync plugins with lazy
  without launching nvim.
- SSH github authentification is a must. Click [here](https://docs.github.com/en/authentication/connecting-to-github-with-ssh/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent)
- GPG key generation for signing commits. Click [here](https://docs.github.com/fr/authentication/managing-commit-signature-verification/generating-a-new-gpg-key)
- My dotfiles are WIP forever.
- add `-k` to let existing .zshrc when installing Zap.
- Run `:checkhealth` in the first launch of Neovim.

## TO-DO

- Add scripts to automate packages installation.
- Add package.txt regrouping all pacman and AUR packages.
- Add and encrypt SSH and GPG key files.
- Add nitrogen or a way to randomize wallpapers on the screen and lockscreen.
