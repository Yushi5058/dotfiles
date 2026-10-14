#!/usr/bin/env bash
# ============================================================================
# migrate-vbox-to-kvm.sh
# Migrate the two VirtualBox VMs (Kali, Windows 11) to native QEMU/KVM
# (libvirt + virt-manager), then optionally remove VirtualBox.
#
# Host: CachyOS (Arch-based). Run as your normal user (uses sudo where needed).
#
# DESIGN / SAFETY
#  - Source VDI files are NEVER modified or deleted (kept as backups).
#  - Destination qcow2 is user-owned under ~/VMs (no sudo for conversion).
#  - Domain definitions use unique names (kali-vbox, win11) so the
#    pre-existing KVM domain 'kali' is preserved untouched.
#  - VirtualBox removal is OFF by default. Enable with:  REMOVE_VBOX=1 ./script
#  - Idempotent: re-running skips existing dest images / defined domains.
# ============================================================================
set -euo pipefail

# ------------------------------- CONFIG ------------------------------------
KALI_SRC="/home/yushi61/Downloads/kali-linux-2026.1-virtualbox-amd64/kali-linux-2026.1-virtualbox-amd64.vdi"
WIN_SRC="/home/yushi61/VirtualBox VMs/windows_vm/windows_vm.vdi"

KALI_NAME="kali-vbox"
WIN_NAME="win11"

KALI_DST="/home/yushi61/VMs/kali-vbox/kali-vbox.qcow2"
WIN_DST="/home/yushi61/VMs/win11/win11.qcow2"

KALI_RAM_MIB=4096      # VBox was 2048; bumped per request (4+ vCPU spec)
KALI_VCPU=4            # VBox was 2
WIN_RAM_MIB=4096       # matches VBox
WIN_VCPU=2             # matches VBox

VIRTIO_ISO="/home/yushi61/Downloads/virtio-win-0.1.285.iso"
OVMF_CODE_SECBOOT="/usr/share/edk2/x64/OVMF_CODE.secboot.4m.fd"
OVMF_VARS="/usr/share/edk2/x64/OVMF_VARS.4m.fd"
OVMF_CODE="/usr/share/edk2/x64/OVMF_CODE.4m.fd"   # used by existing 'kali'
Q35="pc-q35-11.0"                                 # matches existing runtime
NET="default"

REMOVE_VBOX="${REMOVE_VBOX:-0}"   # set to 1 to actually purge VirtualBox
# ---------------------------------------------------------------------------

c() { printf '\n\033[1;34m==> %s\033[0m\n' "$*"; }
warn() { printf '\033[1;33m[!] %s\033[0m\n' "$*"; }
die() { printf '\033[1;31m[x] %s\033[0m\n' "$*" >&2; exit 1; }

preflight() {
  c "Preflight"
  [[ $EUID -ne 0 ]] || die "run as your normal user, not root (script uses sudo internally)"
  command -v qemu-img >/dev/null || die "qemu-img missing"
  command -v virsh   >/dev/null || die "virsh missing"
  [[ -e /dev/kvm ]] || die "/dev/kvm missing (VT-x disabled?)"
  [[ -f "$KALI_SRC" ]] || die "Kali source VDI not found: $KALI_SRC"
  [[ -f "$WIN_SRC"  ]] || die "Windows source VDI not found: $WIN_SRC"
  [[ -f "$VIRTIO_ISO" ]] || die "virtio-win ISO not found: $VIRTIO_ISO"

  # VMs must be powered off in VirtualBox
  if command -v VBoxManage >/dev/null; then
    local running
    running="$(VBoxManage list runningvms 2>/dev/null || true)"
    [[ -z "$running" ]] || die "VirtualBox VMs still running:\n$running\nPower them off first."
  fi

  # Source disks must not be attached/being written: warn if mtime < 30s ago
  c "Disk space check"
  local avail_kb need_kb
  avail_kb=$(df -Pk /home/yushi61 | awk 'NR==2{print $4}')
  # rough: sum of physical source sizes (compression usually shrinks qcow2)
  need_kb=$(( ( $(stat -c %s "$KALI_SRC") + $(stat -c %s "$WIN_SRC") ) / 1024 ))
  printf '  free: %s MiB   source bytes: %s MiB\n' "$((avail_kb/1024))" "$((need_kb/1024))"
  if (( avail_kb < need_kb )); then
    warn "Free space (${avail_kb}K) < source size (${need_kb}K)."
    warn "qcow2 -c compression usually helps, but this may still fail. Free space first"
    warn "(e.g. 'sudo pacman -Sc', clear caches, or move sources to external storage)."
    read -rp "  continue anyway? [y/N] " a; [[ "${a,,}" == y ]] || die "aborted: low disk space"
  fi
}

phase_install() {
  c "Phase 1 — install KVM/virt tooling + enable libvirtd + default network"
  sudo pacman -S --needed --noconfirm \
    qemu-full virt-manager virt-install virt-viewer swtpm libtpms libvirt edk2-ovmf dnsmasq
  sudo systemctl enable --now libvirtd.service
  # start default NAT network (defined but inactive)
  sudo virsh net-start "$NET" >/dev/null 2>&1 || true
  sudo virsh net-autostart "$NET" >/dev/null 2>&1 || true
  virsh --connect qemu:///system net-list --all
}

make_dst_dir() { mkdir -p "$(dirname "$1")"; }

convert_one() {
  local src="$1" dst="$2" label="$2"
  mkdir -p "$(dirname "$DST")"
  if [[ -f "$DST" ]]; then warn "dest exists, skipping: $DST"; return 0; fi
  c "Converting -> $DST  (-c compressed qcow2, progress on)"
  qemu-img convert -p -c -O qcow2 "$SRC" "$DST"
  qemu-img info "$DST" | sed 's/^/  /'
}

phase_convert() {
  c "Phase 2 — convert disks to qcow2 (no sudo; dest under ~/VMs)"
  mkdir -p "$(dirname "$KALI_DST")" "$(dirname "$WIN_DST")"

  if [[ ! -f "$KALI_DST" ]]; then
    c "Kali: converting (this takes a while, ~30 GiB)"
    qemu-img convert -p -c -O qcow2 "$KALI_SRC" "$KALI_DST"
    qemu-img info "$KALI_DST" | sed 's/^/  /'
  else warn "Kali dest exists, skipping: $KALI_DST"; fi

  if [[ ! -f "$WIN_DST" ]]; then
    c "Windows: converting (this takes a while, ~21 GiB)"
    qemu-img convert -p -c -O qcow2 "$WIN_SRC" "$WIN_DST"
    qemu-img info "$WIN_DST" | sed 's/^/  /'
  else warn "Windows dest exists, skipping: $WIN_DST"; fi
}

# Define or re-define a domain. libvirt rejects re-defining an existing domain
# unless the XML carries its current UUID ("already exists with uuid ..."), so
# inject it when the domain is already present.
define_domain() {
  local name="$1" xml="$2"
  if sudo virsh dominfo "$name" >/dev/null 2>&1; then
    [[ "$(sudo virsh domstate "$name" 2>/dev/null)" == "shut off" ]] \
      || die "domain '$name' is running; shut it down before re-defining"
    local uuid; uuid="$(sudo virsh domuuid "$name")"
    sed -i "s#<name>$name</name>#<name>$name</name>\n  <uuid>$uuid</uuid>#" "$xml"
    warn "domain $name exists -> redefining with preserved uuid $uuid"
  fi
  sudo virsh define "$xml"
}

phase_define() {
  c "Phase 3 — define libvirt domains (sudo virsh define)"

  # ---- Kali: BIOS / i440fx (VBox was BIOS+MBR; UEFI would not boot) ----
  cat > /tmp/${KALI_NAME}.xml <<EOF
<domain type='kvm'>
  <name>${KALI_NAME}</name>
  <memory unit='MiB'>${KALI_RAM_MIB}</memory>
  <currentMemory unit='MiB'>${KALI_RAM_MIB}</currentMemory>
  <vcpu placement='static'>${KALI_VCPU}</vcpu>
  <os>
    <type arch='x86_64' machine='pc'>hvm</type>
  </os>
  <features><acpi/><apic/></features>
  <cpu mode='host-passthrough' check='none' migratable='on'/>
  <clock offset='utc'>
    <timer name='rtc' tickpolicy='catchup'/>
    <timer name='pit' tickpolicy='delay'/>
    <timer name='hpet' present='no'/>
  </clock>
  <on_poweroff>destroy</on_poweroff><on_reboot>restart</on_reboot><on_crash>destroy</on_crash>
  <devices>
    <emulator>/usr/bin/qemu-system-x86_64</emulator>
    <disk type='file' device='disk'>
      <driver name='qemu' type='qcow2' discard='unmap'/>
      <source file='${KALI_DST}'/>
      <target dev='vda' bus='virtio'/>
      <boot order='1'/>
    </disk>
    <interface type='network'><source network='${NET}'/><model type='virtio'/></interface>
    <graphics type='spice' autoport='yes'><listen type='address'/></graphics>
    <video><model type='qxl'/></video>
    <channel type='spicevmc'><target type='virtio' name='com.redhat.spice.0'/></channel>
    <channel type='unix'><target type='virtio' name='org.qemu.guest_agent.0'/></channel>
  </devices>
</domain>
EOF

  # ---- Windows 11: Q35 + UEFI Secure Boot + swtpm TPM 2.0 + virtio-win ISO ----
  cat > /tmp/${WIN_NAME}.xml <<EOF
<domain type='kvm'>
  <name>${WIN_NAME}</name>
  <memory unit='MiB'>${WIN_RAM_MIB}</memory>
  <currentMemory unit='MiB'>${WIN_RAM_MIB}</currentMemory>
  <vcpu placement='static'>${WIN_VCPU}</vcpu>
  <os firmware='efi'>
    <type arch='x86_64' machine='${Q35}'>hvm</type>
    <firmware>
      <feature enabled='yes' name='secure-boot'/>
    </firmware>
    <loader readonly='yes' secure='yes' type='pflash' format='raw'>${OVMF_CODE_SECBOOT}</loader>
    <nvram template='${OVMF_VARS}' templateFormat='raw' format='raw'>/var/lib/libvirt/qemu/nvram/${WIN_NAME}_VARS.fd</nvram>
  </os>
  <features><acpi/><apic/><smm state='on'/></features>
  <cpu mode='host-passthrough' check='none' migratable='on'/>
  <clock offset='localtime'>
    <timer name='rtc' tickpolicy='catchup'/>
    <timer name='pit' tickpolicy='delay'/>
    <timer name='hpet' present='no'/>
  </clock>
  <on_poweroff>destroy</on_poweroff><on_reboot>restart</on_reboot><on_crash>destroy</on_crash>
  <devices>
    <emulator>/usr/bin/qemu-system-x86_64</emulator>
    <disk type='file' device='disk'>
      <driver name='qemu' type='qcow2' discard='unmap'/>
      <source file='${WIN_DST}'/>
      <target dev='sda' bus='sata'/>
      <boot order='1'/>
    </disk>
    <disk type='file' device='cdrom'>
      <driver name='qemu' type='raw'/>
      <source file='${VIRTIO_ISO}'/>
      <target dev='sdb' bus='sata'/>
      <readonly/>
    </disk>
    <tpm model='tpm-crb'><backend type='emulator' version='2.0'/></tpm>
    <interface type='network'><source network='${NET}'/><model type='e1000'/></interface>
    <graphics type='spice' autoport='yes'><listen type='address'/></graphics>
    <video><model type='qxl'/></video>
    <channel type='spicevmc'><target type='virtio' name='com.redhat.spice.0'/></channel>
    <channel type='unix'><target type='virtio' name='org.qemu.guest_agent.0'/></channel>
  </devices>
</domain>
EOF

  define_domain "$KALI_NAME" "/tmp/${KALI_NAME}.xml"
  define_domain "$WIN_NAME"  "/tmp/${WIN_NAME}.xml"
}

phase_validate() {
  c "Phase 4 — validate domains"
  sudo virsh list --all
  for d in "$KALI_NAME" "$WIN_NAME"; do
    echo "--- dominfo $d"; sudo virsh dominfo "$d" | sed 's/^/  /'
    echo "--- xml integrity"; sudo virsh dumpxml "$d" >/dev/null && echo "  dumpxml OK"
  done
  cat <<'EOF'

  Boot-test (optional, opens a window):
    virt-manager                 # then start each VM, watch it boot
  Headless quick check:
    sudo virsh start kali-vbox && sudo virsh console kali-vbox   # Ctrl-] to exit
    sudo virsh start win11
  If Kali shows "no bootable device": switch its machine type/disk bus, or
  confirm the VDI was indeed BIOS/MBR (it was, per VBox firmware=BIOS).
  If Win11 fails Secure Boot: edit domain -> remove secure-boot feature.
EOF
}

phase_remove_vbox() {
  c "Phase 5 — remove VirtualBox"
  if [[ "$REMOVE_VBOX" != "1" ]]; then
    warn "REMOVE_VBOX != 1 -> skipping VirtualBox removal."
    warn "Re-run with:  REMOVE_VBOX=1 $0"
    warn "Only do this AFTER both VMs boot correctly under KVM."
    return
  fi
  echo "  Backups kept: '$KALI_SRC', '$WIN_SRC', ~/'VirtualBox VMs'/, ~/.config/VirtualBox"
  read -rp "  Purge virtualbox + host-dkms + ext-oracle now? [y/N] " a
  [[ "${a,,}" == y ]] || { warn "skipped"; return; }

  sudo systemctl disable --now vboxweb.service 2>/dev/null || true
  sudo modprobe -r vboxnetflt vboxnetadp vboxdrv 2>/dev/null || true

  local vbpkgs
  vbpkgs="$(pacman -Qsq '^virtualbox' 2>/dev/null || true)"
  [[ -n "$vbpkgs" ]] && sudo pacman -Rns $vbpkgs || warn "no virtualbox packages found"

  echo "  remaining vbox modules:"; (lsmod | grep -i vbox || echo "    none")
  warn "Global dir ~/.config/VirtualBox left in place (safe to delete manually later)."
}

main() {
  preflight
  phase_install
  phase_convert
  phase_define
  phase_validate
  phase_remove_vbox
  c "Done. Next: boot both VMs, verify, then (optionally) REMOVE_VBOX=1 re-run."
}

main "$@"
