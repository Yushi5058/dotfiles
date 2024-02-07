#!/usr/bin/env bash

# Otherwise you can use the nuclear option:
 killall -q polybar

# Wait until the processes have been shut down
while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done

# Launch bar1
polybar main -r
