# Hardware — ThinkPad X13 Yoga Gen 2

| Feature | Notes |
|---------|-------|
| CPU | Intel i5-1145G7 (4C/8T, up to 4.4 GHz) |
| GPU | Intel Iris Xe (96 EU) |
| RAM | 16GB (no swap — zram with zstd) |
| Storage | 256GB NVMe |
| Display | 13.3" WUXGA (1920×1200) touch, Wacom AES stylus |
| WiFi/BT | Intel AX201 (WiFi 6), OOTB |
| Ports | 2× USB-C (TB4), 2× USB-A, HDMI 2.0, 3.5mm, microSD |

## Sway Input Config

```bash
swaymsg -t get_inputs   # find device IDs
```

```text
# TrackPoint
input "TPPS/2 IBM TrackPoint" {
    accel_profile adaptive
    pointer_accel -0.4
    scroll_method on_button_down
    scroll_button 272
}

# Touchpad
input type:touchpad {
    dwt enabled
    tap enabled
    natural_scroll enabled
    pointer_accel 0.2
}

# Touchscreen — disabled by default to avoid accidental input
input type:touch {
    events disabled
}
```