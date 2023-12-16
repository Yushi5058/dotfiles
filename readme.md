# About the project
Hello everyone,
This is my dotfiles configuration, please do not copy it unless you know what
each line of code does mean.

I am currently experiencing as a poweruser, configuration and customization
may change depending on my workflow. Expect to see this repository has many
changes over times.

# Usage

ps : These dotfiles work on **Fedora Linux**. I don't know if it will
also work for other distributions.

If you would like to use my configuration, there are some requirements to make
it work as expected.

- post-installation guide of fedora : 

{

-> edit /etc/dnf/dnf.conf to add `max_parallel_downloads=10` and `fastestmirror=true`

-> install rpm-fusion : 
```
sudo dnf install https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm

sudo dnf install https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm`
```

-> install multimedia plugins : 
```
sudo dnf install vlc
sudo dnf install gstreamer1-plugins-{bad-\*,good-\*,base} gstreamer1-plugin-openh264 gstreamer1-libav --exclude=gstreamer1-plugins-bad-free-devel

sudo dnf install lame\* --exclude=lame-devel

sudo dnf group upgrade --with-optional Multimedia

```

}
- Install kitty terminal [here](https://sw.kovidgoyal.net/kitty/binary/)
- Install CaskaydiaCove NerdFont [here](https://github.com/ryanoasis/nerd-fonts/releases/download/v3.0.2/CascadiaCode.zip),
 [preview](https://www.programmingfonts.org/#cascadia-code)
- Install DaddyTime for UI Font [here](https://github.com/ryanoasis/nerd-fonts/releases/download/v3.0.2/DaddyTimeMono.zip),
 [preview](https://www.programmingfonts.org/#daddytimemono)
- Install nodejs (npm included) and ripgrep (installed on most linux distros)
- Install fd-finder [here](https://github.com/sharkdp/fd)
- Install packer plugin manager [here](https://github.com/wbthomason/packer.nvim)
- Configure ssh key for github authentification [here](https://docs.github.com/en/authentication/connecting-to-github-with-ssh)
- Install fish
- Install bat (replacement for cat), eza (replacement for ls), and btop (replacement for htop)
- Switching desktop environments from gnome to kde with `dnf group install @kde-environment` and install switchdesk 
- Upgrade to the latest release with `sudo dnf system-upgrade download --releasever=39` for fedora 39 for example
- Touchpad enable tap-to-click and natural scrolling (invert scroll)
- Connect to whatsapp web and discord, connect to mozilla account for firefox sync extensions
- Activate night control 
- Install spotify trough flatpak 
- Don't forget to add flathub : `flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo`
- The fonts files must be copied to $HOME/usr/share/fonts path to be used.
- Install neovim from dnf, and neovim with npm `npm install -g neovim`
- Install clang compiler for neovim treesitter `dnf install clang`
- Install lazygit for neovim [here](https://github.com/jesseduffield/lazygit#installation)

