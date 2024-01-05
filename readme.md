# About the project

\__These are my dotfiles, don't use it unless you know what each line of code means._

## Requirements

- Fedora 39
- Rpm fusion free and non-free
- Multimedia plugins
- Wezterm, bat, eza, btop, neovim, clang
- Spotify (flatpak), OBS-studio(rpm fusion), Min browser
- Discord (flatpak)
- Zsh shell with oh-my-zsh framework

## Usage

### Post-installation guide

- edit /etc/dnf/dnf.conf\_

```bash
max_parallels_downloads = 10
fastestmirror = true
```

- install rpm fusion free and non free\_

```bash
$ sudo dnf install https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm
```

source: [here](https://rpmfusion.org/Configuration)

- install multimedia plugins\_

```bash
$ sudo dnf install gstreamer1-plugins-{bad-\*,good-\*,base} gstreamer1-plugin-openh264 gstreamer1-plugin-libav --exclude=gstreamer1-plugins-bad-free-devel

$ sudo dnf install lame\* --exclude=lame-devel

$ sudo dnf group upgrade --with-optional Multimedia

$ sudo dnf install ffmpeg libavcodec-freeworld --best --allowerasing
```

source: [here](https://docs.fedoraproject.org/en-US/quick-docs/installing-plugins-for-playing-movies-and-music/)

- add flatpak's remote: flathub\_

```bash
$ flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
```

source: [here](https://flathub.org/setup/Fedora)

### Apps

- Install apps : Wezterm, btop, eza, bat, neovim, clang, obs-studio, min-browser,
  flameshot
- Install flatpak apps: spotify
- Install nodejs dependencies eg. neovim
- Install oh-my-zsh framework [here](https://ohmyz.sh/#install)

### Utils

- Configure [ssh-key](https://docs.github.com/en/authentication/connecting-to-github-with-ssh)
  for github authentication.
- Use DaddyTimeMono NF for usage font and Hack NF for code font.
- Activate night control in settings.
- Enable touchpad tap-to-click and natural scrolling in settings.

## Note

The dotfiles are in constant change.
