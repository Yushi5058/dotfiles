# DFIR Setup

DFIR tooling runs in a **Kali Linux VM** under **QEMU/KVM** (libvirt + `virt-manager`); the host stays lean.
A **Windows 11 VM** (malware analysis) runs alongside it.

Both VMs were **migrated from VirtualBox** (VDI → compressed qcow2, disks under `~/VMs/`).

| Domain | Machine / Firmware | Disk | NIC | Status |
|--------|--------------------|------|-----|--------|
| `kali-vbox` | `i440fx` (`pc`), **BIOS** | virtio (`vda`) | virtio | ✅ boots (Kali ships virtio drivers) |
| `win11` | `q35`, **UEFI + Secure Boot**, TPM 2.0 | **SATA** (`sda`) | **e1000** | ✅ boots |

> A pre-existing `kali` domain (UEFI, `/var/lib/libvirt/images/kali.qcow2`) is unrelated and left untouched.
> VirtualBox is removed once both VMs are verified (see [Removing VirtualBox](#removing-virtualbox)).

## Host setup (one-time)

```bash
sudo pacman -S --needed qemu-full virt-manager virt-install virt-viewer \
    swtpm libtpms libvirt edk2-ovmf dnsmasq

sudo systemctl enable --now libvirtd.service
sudo virsh net-start default && sudo virsh net-autostart default   # NAT net 192.168.122.0/24

sudo usermod -aG libvirt,kvm "$USER"
# LOG OUT and back IN — group membership only applies to new sessions.
```

virtio-win ISO lives at `~/Downloads/virtio-win-0.1.285.iso` (attached to `win11` as SATA CD-ROM `sdb`).

## Migrating from VirtualBox

Reproducible script: [`scripts/migrate-vbox-to-kvm.sh`](../scripts/migrate-vbox-to-kvm.sh).
It converts the VDIs, defines both domains, validates, then optionally removes VirtualBox (`REMOVE_VBOX=1`).

```bash
# dry-ish run (installs packages, converts, defines; keeps VirtualBox)
bash scripts/migrate-vbox-to-kvm.sh

# once both VMs boot cleanly:
REMOVE_VBOX=1 bash scripts/migrate-vbox-to-kvm.sh
```

Key steps: `qemu-img convert -p -c -O qcow2` (compressed, no sudo — dest is user-owned under `~/VMs/`),
then `virsh define` per domain. Source VDIs are never modified.

### Boot pitfalls hit during migration

| Problem | Cause | Fix |
|---------|-------|-----|
| `virsh define` → *"per-device boot elements cannot be used together with os/boot"* | XML had both `<os><boot dev='hd'/></os>` and `<disk><boot order='1'/></disk>` | Use per-device `<boot order='1'/>` **only** |
| `virsh define` → *"Unable to find 'efi' firmware that is compatible"* | requested `<feature name='enrolled-keys' enabled='yes'/>`; Arch's OVMF descriptor (`/usr/share/qemu/firmware/50-edk2-ovmf-x86_64-secure-4m.json`) does **not** advertise `enrolled-keys` | Keep only `<feature name='secure-boot' enabled='yes'/>` |
| `virsh define` → *"domain 'win11' already exists with uuid …"* | re-defining an existing domain without its UUID | inject the current UUID (`virsh domuuid win11`) into the XML |
| Win11 BSOD `INACCESSIBLE_BOOT_DEVICE` | VBox ran it on **SATA/AHCI**; moved to virtio disk | set `<target dev='sda' bus='sata'/>` (virtio needs drivers installed first) |
| Win11 no network | NIC was virtio | use `model='e1000'` (matches the VBox NIC) until virtio-net is installed |
| Kali "no bootable device" | VBox image is **BIOS/MBR** | machine must be `pc` (i440fx), not UEFI |

## Managing VMs

Use the **system** connection. Once you're in the `libvirt` group (after the re-login) no sudo is needed.

```bash
virsh -c qemu:///system list --all
virsh -c qemu:///system start    kali-vbox
virsh -c qemu:///system start    win11
virt-viewer -c qemu:///system kali-vbox     # SPICE console (or the virt-manager GUI)
virsh -c qemu:///system shutdown win11       # graceful stop
virsh -c qemu:///system autostart win11      # start on host boot
virsh console kali-vbox                       # serial console (Ctrl-] to exit)
```

> **Never `sudo` a GUI app.** `sudo` drops your `DISPLAY`/`XAUTHORITY` → `cannot open display :0`.
> If your shell predates the group change: `sg libvirt -c 'virt-viewer -c qemu:///system kali-vbox'`.

### Clipboard (host ↔ guest)

Needs the SPICE guest agent; the `com.redhat.spice.0` channel is already in both domains.

- **Kali**: `sudo apt install -y spice-vdagent && sudo systemctl enable --now spice-vdagentd`, then **log out/in**.
- **Windows**: install **SPICE Guest Tools** (spice-space.org) and reboot. (virtio-win's guest tools do *not* include vdagent.)
- Then plain `Ctrl+C` / `Ctrl+V` works automatically in the virt-manager console.

## Post-install — Kali guest (`kali-vbox`)

```bash
sudo apt update && sudo apt full-upgrade -y

# Guest agents: QEMU (host control) + SPICE (clipboard / auto-resize)
sudo apt install -y qemu-guest-agent spice-vdagent
sudo systemctl enable --now qemu-guest-agent

# Drop leftovers from the VirtualBox image
sudo apt purge -y 'virtualbox-guest-*' 2>/dev/null || true
```

Optional tooling bundles:

```bash
sudo apt install -y \
    kali-linux-headless kali-tools-forensics \
    kali-tools-reverse-engineering kali-tools-web \
    kali-tools-password-recovery kali-tools-exploitation \
    kali-tools-crypto-stego kali-tools-information-gathering \
    kali-tools-vulnerability
```

Check networking: `ip -4 addr` should show a `192.168.122.x` address on the virtio NIC.

## Post-install — Windows 11 guest (`win11`)

First boot: Q35 UEFI (OVMF secure boot) → SATA disk `sda`, TPM 2.0 attached, NAT NIC (`e1000`).
The NIC is `e1000` so Windows has a network driver **before** virtio-win is installed.

1. **Install virtio-win drivers** — open the attached CD (`sdb`), run `virtio-win-guest-tools.exe`
   (installs virtio-net/blk/balloon + QEMU guest agent + QXL display driver). Reboot.
2. **Install SPICE Guest Tools** — clipboard and dynamic resolution.
3. **Remove VirtualBox Guest Additions** (Control Panel → Programs).
4. **Autostart**: `virsh -c qemu:///system autostart win11`.
5. **Optional — switch storage/net to virtio** (only *after* step 1; else `INACCESSIBLE_BOOT_DEVICE`):

   ```bash
   virsh -c qemu:///system edit win11
   # disk:  <target dev='sda' bus='sata'/>   ->   <target dev='vda' bus='virtio'/>
   # NIC :  <model type='e1000'/>            ->   <model type='virtio'/>
   ```

> **Secure Boot** boots in **setup mode**: Arch's `edk2-ovmf` ships no pre-enrolled keys (its firmware
> descriptor omits `enrolled-keys`). Windows runs fine; enroll keys only if you need SB *enforcement*.

## Snapshots (take one after a clean, patched state)

```bash
virsh -c qemu:///system snapshot-create-as kali-vbox "clean-install" --disk-only --atomic
virsh -c qemu:///system snapshot-list    kali-vbox
virsh -c qemu:///system snapshot-revert  kali-vbox "clean-install"

virsh -c qemu:///system snapshot-create-as win11 "before-engagement" --disk-only --atomic
virsh -c qemu:///system snapshot-revert  win11 "before-engagement"
```

## Shared folder (virtiofs)

```
# Host: virt-manager -> Add Hardware -> Filesystem
#   driver = virtiofs, source = ~/Cases, target = cases
```

Kali guest:

```bash
sudo mkdir -p /mnt/cases
sudo mount -t virtiofs cases /mnt/cases
# /etc/fstab:  cases  /mnt/cases  virtiofs  defaults,nofail  0  0
```

Windows guest needs the virtio-win **virtio-fs** driver + WinFsp (both in the ISO).

## Troubleshooting

| Symptom | Cause / fix |
|---------|-------------|
| `virt-viewer` "cannot open display :0" | You used `sudo`. Run the GUI as your user (or `sg libvirt -c '…'`). |
| `virt-viewer` "No running virtual machine found" | Wrong connection — use `-c qemu:///system`; confirm state with `virsh -c qemu:///system list --all`. |
| Clipboard doesn't work | Guest agent not running (`spice-vdagentd`, or SPICE Guest Tools on Windows); channel missing; or a Wayland guest. |
| Win11 BSOD `INACCESSIBLE_BOOT_DEVICE` | Disk on virtio without drivers — set `bus='sata'`. |
| Win11 has no network | Set `model='e1000'` until virtio-net is installed. |
| Kali: "no bootable device" | Must be i440fx **BIOS** (`machine='pc'`); UEFI won't boot the VBox image. |
| `virsh define`: "Unable to find 'efi' firmware …" | Don't request `enrolled-keys=yes` (Arch OVMF omits it). Keep only `secure-boot`. |
| `virsh define`: "per-device boot elements cannot be used with os/boot" | Don't mix `os/boot` and per-device `<boot>`; use the latter only. |
| `virsh define` "already exists with uuid …" | Re-inject the existing UUID (`virsh domuuid <name>`). |

## Removing VirtualBox

Do this **only after both VMs boot cleanly**. The package lists (`base.txt`/`aur.txt`) no longer reference VirtualBox.

```bash
sudo pacman -Rns virtualbox virtualbox-host-dkms virtualbox-ext-oracle
```

Then delete the source VDIs (kept only as migration backups until verified):

```bash
rm -rf "$HOME/VirtualBox VMs" ~/.config/VirtualBox
```

## Disk notes

The VMs live under `~/VMs/` and grow as guests write. Keep headroom on `/` (btrfs):
`sudo pacman -Sc` clears the pacman cache, and `~/.local/share/Trash` + `~/.cache` are the usual offenders.
