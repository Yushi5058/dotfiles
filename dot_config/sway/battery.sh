#!/bin/bash
# Low battery notifier

# Kill already running processes
already_running="$(ps -fC 'grep' -N | grep 'battery.sh' | wc -l)"
if [[ $already_running -gt 1 ]]; then
	pkill -f --older 1 'battery.sh'
fi


while [[ 0 -eq 0 ]]; do
	battery_status="$(cat /sys/class/power_supply/BAT0/status)"
	battery_charge="$(cat /sys/class/power_supply/BAT0/capacity)"

	if [[ $battery_status == 'Discharging' && $battery_charge -le 85 ]]; then
		if   [[ $battery_charge -le 15 ]]; then
			notify-send --icon="/usr/share/icons/rose-pine-icons/16x16/devices/battery.svg" --urgency=critical "Battery critical!" "${battery_charge}%"
			sleep 180
		elif [[ $battery_charge -le 20 ]]; then
			notify-send --icon="/usr/share/icons/rose-pine-icons/16x16/devices/battery.svg" --urgency=critical "Battery critical!" "${battery_charge}%"
			sleep 240
		fi
	else
		sleep 600
	fi
	if [[$battery_status == 'Full']]; then
		notify-send --icon="/usr/share/icons/rose-pine-icons/16x16/devices/battery.svg" "Battery full!"
		sleep 180
	fi
done
