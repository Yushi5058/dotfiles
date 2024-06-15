
#!/bin/bash

# Infinite loop to continuously monitor battery status
while true; do
    # Get battery percentage
    battery_percentage=$(cat /sys/class/power_supply/BAT0/capacity)
    # Get battery status (Charging, Discharging, Full, etc.)
    battery_status=$(cat /sys/class/power_supply/BAT0/status)

    # Check battery levels and send notifications
    if [ "$battery_status" = "Discharging" ]; then
        if [ "$battery_percentage" -le 5 ]; then
            notify-send -u critical "Battery Critical" "Battery level is at $battery_percentage%. Please plug in your charger!"
        elif [ "$battery_percentage" -le 15 ]; then
            notify-send -u normal "Battery Urgent" "Battery level is at $battery_percentage%. Consider plugging in your charger."
        elif [ "$battery_percentage" -le 20 ]; then
            notify-send -u low "Battery Warning" "Battery level is at $battery_percentage%. Keep an eye on your battery."
        fi
    elif [ "$battery_status" = "Charging" ] && [ "$battery_percentage" -eq 100 ]; then
        notify-send -u low "Battery Full" "Battery is fully charged at 100%. Consider unplugging your charger."
    fi

    # Sleep for 60 seconds before checking again
    sleep 60
done
