# DFIR Setup

DFIR tooling runs in a **Kali Linux VM** (VirtualBox). Host stays lean. Windows 11 VM also in VirtualBox (malware analysis).

## Kali VM Setup

```bash
sudo apt update && sudo apt full-upgrade -y
sudo apt install -y \
    kali-linux-headless kali-tools-forensics \
    kali-tools-reverse-engineering kali-tools-web \
    kali-tools-password-recovery kali-tools-exploitation \
    kali-tools-crypto-stego kali-tools-information-gathering \
    kali-tools-vulnerability

sudo apt install -y \
    burpsuite bloodhound impacket-scripts responder wireshark \
    gdb pwntools ropper seclists gobuster ffuf \
    jq exiftool steghide binwalk p7zip-full

# VirtualBox Guest Additions
sudo apt install -y virtualbox-guest-dkms virtualbox-guest-utils virtualbox-guest-x11
sudo systemctl enable --now vboxservice
```

## Windows 11 VM

```bash
# Host: VirtualBox + Extension Pack
sudo pacman -S virtualbox virtualbox-host-dkms virtualbox-ext-oracle
sudo gpasswd -a $USER vboxusers
# Reboot or: newgrp vboxusers

# VM: 4 vCPU, 8GB RAM, 64GB+ VDI, EFI, TPM 2.0 enabled
# VirtIO drivers during setup (fedorapeople.org), Guest Additions after install
```

## Snapshots

```bash
VBoxManage snapshot kali-vm take "Clean Install"
VBoxManage snapshot kali-vm take "Before CTF-xyz"
VBoxManage snapshot kali-vm restore "Clean Install"

VBoxManage snapshot win11-vm take "Before Engagement"
VBoxManage snapshot win11-vm restore "Clean Install"
```

## Shared folder

```bash
# Host
VBoxManage sharedfolder add kali-vm --name cases --hostpath ~/Cases --automount

# Kali
sudo mkdir -p /mnt/cases
sudo mount -t vboxsf cases /mnt/cases
# /etc/fstab:  cases  /mnt/cases  vboxsf  defaults,uid=1000,gid=1000  0  0
```