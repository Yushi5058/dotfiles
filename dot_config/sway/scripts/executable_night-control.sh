#!/bin/bash

# before running kill any instances
exec pkillall wlsunset
# Run wlsunset with Casablanca / Morocco lat & long
# exec wlsunset -l 33.5 -L -7.6
exec wlsunset -t 3500

# additionnal : execute caffeine-ng (workaround until I find a solution with sway)
exec caffeine

