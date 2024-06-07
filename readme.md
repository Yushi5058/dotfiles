# Dotfiles

Managed with [chezmoi](https://www.chezmoi.io/)

## Overview

- _Terminal Environment_ : zsh + tmux + wezterm
- _Menu Launcher_ : [Rofi](https://github.com/davatorium/rofi)
- _Window Manager_ : [Sway-wm](https://github.com/swaywm/)
- _Status Bar_ : [Waybar](https://github.com/Alexays/Waybar/)
- _Shell plugin manager_ : [Zap](https://github.com/zap-zsh/zap) + [Starship](https://starship.rs/)
- _Notification daemon_ : [Mako](https://github.com/emersion/mako)
- _Code Text Editor_ : [Neovim](https://github.com/neovim/neovim)
- _Code Font_ : [Maple](https://github.com/subframe7536/Maple-font/)
- _Regular Font_ : [Cantarell](https://fonts.google.com/specimen/Cantarell)
- _Icons Font_ : [FontAwesome](https://github.com/FortAwesome/Font-Awesome)
- _Login Manager_ : [Ly](https://github.com/fairyglade/ly)
- _File Manager_ : Yazi
- _Browser_ : Firefox

## Notice

- `chsh -s /usr/bin/zsh` to make zsh the default shell.
- `$ nvim --headless "+Lazy!sync" +qa` to sync plugins with lazy
  without launching nvim.
- SSH github authentification is a must. Click [here](https://docs.github.com/en/authentication/connecting-to-github-with-ssh/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent)
- GPG key generation for signing commits. Click [here](https://docs.github.com/fr/authentication/managing-commit-signature-verification/generating-a-new-gpg-key)
- My dotfiles are WIP forever.
- add `-k` to let existing .zshrc when installing Zap.
- Run `:checkhealth` in the first launch of Neovim.
- Install tree-sitter-cli.
- Install [chaotic-aur](https://aur.chaotic.cx/)

## TO-DO

- Add scripts to automate packages installation.
