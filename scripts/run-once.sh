#!/usr/bin/env bash
set -euo pipefail

name="$1"
shift

if ! pgrep -x "$name" > /dev/null 2>&1; then
    exec "$@"
fi
