#!/usr/bin/env bash
set -euo pipefail

# disable dunst
dunstctl set-paused true

# lock screen
betterlockscreen -l
