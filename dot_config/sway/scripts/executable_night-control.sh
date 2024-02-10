#!/bin/bash

# before running kill any instances
exec pkillall wlsunset
# Run wlsunset
exec wlsunset -t 3500


