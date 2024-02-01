# About the project

_These are my dotfiles, don't use it unless you know what each line of code means._

_The dotfiles are managed by [chezmoi](https://www.chezmoi.io/)_

```bash
$ sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply $GITHUB_USERNAME
```

## Requirements

- Fedora 39
- Rpm fusion free and non-free
- Multimedia plugins
- Kitty terminal, bat, eza, btop, neovim
- Spotify (flatpak), OBS-studio(rpm fusion), Min browser
- Discord (flatpak), Obsidian(flatpak)
- Flameshot (screenshoot)
- Zsh shell with zap plugin manager
- xplr file explorer
* linked (journaling), steam, krita
* caffeine-ng
- kvantum-manager with graphite kde theme, tela-dark icon, and breeze cursor

## Usage

### Post-installation guide

_edit /etc/dnf/dnf.conf_

```bash
max_parallels_downloads = 10
fastestmirror = true
```

_install rpm fusion free and non free_

```bash
$ sudo dnf install https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm
```

source: [here](https://rpmfusion.org/Configuration)

_install multimedia plugins_

```bash
$ sudo dnf install gstreamer1-plugins-{bad-\*,good-\*,base} gstreamer1-plugin-openh264 gstreamer1-plugin-libav --exclude=gstreamer1-plugins-bad-free-devel

$ sudo dnf install lame\* --exclude=lame-devel

$ sudo dnf group upgrade --with-optional Multimedia

$ sudo dnf install ffmpeg libavcodec-freeworld --best --allowerasing
```

source: [here](https://docs.fedoraproject.org/en-US/quick-docs/installing-plugins-for-playing-movies-and-music/)

_add flatpak's remote: flathub_

```bash
$ flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
```

source: [here](https://flathub.org/setup/Fedora)

_install kde plasma de-environment_

```bash
$ sudo dnf install @kde-desktop-environment
```

### Apps

- Install apps : Kitty terminal, btop, eza, bat, neovim, clang, obs-studio, min-browser,
  flameshot, xplr, fim
- Install flatpak apps: spotify, discord, obsidian
- Install nodejs dependencies eg. neovim
- Install zap zsh plugin manager

### Utils

- Configure [gpg-key](https://docs.github.com/en/authentication/managing-commit-signature-verification/generating-a-new-gpg-key)
  for github authentication.
- Use DaddyTimeMono NF for usage font and Hack NF for code font.
- Activate night control in settings.
- Enable touchpad tap-to-click and natural scrolling in settings.

## Note

* The dotfiles are in constant change. (WIP)
* I will probably use Endeavour OS in the future.
* I will use scripts to automate the installation of my apps in the future.
