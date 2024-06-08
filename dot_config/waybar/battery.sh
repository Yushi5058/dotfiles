#!/bin/bash

# Battery thresholds for notifications (change as needed)
LOW_THRESHOLD=20
FULL_THRESHOLD=100

# Get current battery percentage using /sys/class/power_supply

BATTERY_STATUS=$(cat /sys/class/power_supply/BAT0/status)
BATTERY_CAPACITY=$(cat /sys/class/power_supply/BAT0/capacity)

# Check if battery is fully charged
if [ "$BATTERY_STATUS" == "Full" ] || [ "$BATTERY_CAPACITY" -eq 100 ]; then
# Display a notification for full battery
    notify-send "Battery Full" -u critical -i "battery-full"
fi

# Check if battery percentage is below the low threshold
if [ "$BATTERY_CAPACITY" -le "$LOW_THRESHOLD" ]; then
# Display a low battery notification
    notify-send "Battery low" "Battery is at ${BATTERY_CAPACITY}%" -u critical -i "battery-caution"
fi
