#!/bin/bash
# This script will notify you when your battery is low.
# It will check all batteries and notify you when both of them are below the threshold.
# It will also check if the laptop is charging or not.
# If you want to run this script automatically, you can add it to your crontab.
# To do so, run "crontab -e" and add the following line:
# */5 * * * * /bin/bash /path/to/battery_notif.sh

# Percentage threshold.
# If all batteries are below this threshold, you will be notified.
# Change this to your liking.
THRESHOLD=20

# Notification expire time in milliseconds.
EXPIRE_TIME=10000

# Defaults
NOT_CHARGING=0
TOTAL_CAPACITY=0.0
CURRENT_CAPACITY=0.0
POWER=$(ls /sys/class/power_supply | grep "AC")
POWERSUPPLY="/sys/class/power_supply/$POWER/online"
STATUS=$(cat $POWERSUPPLY)

# This is needed to display the notification on the desktop when the scripts is called as a cronjob.
# Tested with sway v1.7.
export XDG_RUNTIME_DIR=/run/user/$(id -u)
export DISPLAY=:0

# Get all batteries
mapfile -t BATTERY_PATHS < <(upower -e | grep battery)

# Calculate the total and current capacity of all batteries
for BATTERY_PATH in "${BATTERY_PATHS[@]}"; do
    BATTERY_PERCENTAGE=$(upower -i "$BATTERY_PATH" | grep percentage | awk '{print $2}' | sed 's/%//')
    total_capacity=$(upower -i $BATTERY_PATH | grep "energy-full:" | awk '{print $2}')
    TOTAL_CAPACITY=$(echo "$TOTAL_CAPACITY + $total_capacity" | bc)
    current_capacity=$(upower -i $BATTERY_PATH | grep "energy:" | awk '{print $2}')
    CURRENT_CAPACITY=$(echo "$CURRENT_CAPACITY + $current_capacity" | bc)
done

# Calculate the current percentage and round to whole number
CURRENT_PERCENTAGE=$(echo $CURRENT_CAPACITY/$TOTAL_CAPACITY*100 | bc -l | cut -d "." -f 1)

# Send a notification if the total capacity is below the threshold and the laptop is not charging
if [ "$CURRENT_PERCENTAGE" -lt $THRESHOLD -a $STATUS = $NOT_CHARGING ]; then
    /usr/bin/notify-send "Low battery warning" "Current capacity at $CURRENT_PERCENTAGE%" --icon=battery-low --expire-time=$EXPIRE_TIME --urgency=normal
    /usr/bin/paplay /usr/share/sounds/Yaru/stereo/battery-low.oga
fi
