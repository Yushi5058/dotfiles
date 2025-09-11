## Fedora KDE performance tweaks (i5‑7300U / 8 GB)

- **Trim Plasma UI**
  - Remove unwanted widgets:  
    `Right‑click panel → Edit Panel → Remove widgets`
  - Disable heavy effects:  
    `System Settings → Workspace → Desktop Effects → Turn off Blur, Slide, Fade…`
  - Switch to a lightweight theme (e.g., Breeze):  
    `System Settings → Appearance → Global Theme → Breeze`

- **Power & CPU scaling**
  - Install and enable TLP (auto‑optimises power states):
    ```bash
    sudo dnf install tlp tlp-rdw
    sudo systemctl enable --now tlp
    ```
  - (Optional) Force performance governor for short bursts (use on AC only):
    ```bash
    sudo dnf install kernel-tools   # provides cpupower
    sudo cpupower frequency-set -g performance
    # revert to powersave when done
    sudo cpupower frequency-set -g powersave
    ```

- **Compressed swap cache (zswap)**
  - Enable zswap with LZ4 compression (requires reboot):
    ```bash
    sudo grubby --update-kernel=ALL --args="zswap.enabled=1 zswap.compressor=lz4"
    ```
  - Verify after reboot:
    ```bash
    cat /sys/module/zswap/parameters/enabled   # should output Y
    ```

- **Lower swappiness (keep data in RAM longer)**
  - Temporary change (until next reboot):
    ```bash
    sudo sysctl vm.swappiness=10
    ```
  - Persistent change:
    ```bash
    echo 'vm.swappiness = 10' | sudo tee /etc/sysctl.d/99-swappiness.conf
    ```

- **Early OOM killer (prevents freezes)**
  ```bash
  sudo dnf install earlyoom
  sudo systemctl enable --now earlyoom
  ```
