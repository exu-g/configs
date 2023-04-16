#!/usr/bin/env sh
set -euo pipefail

git fetch -a
git reset --hard
git clean -fd
git pull

# regenerate hardware config
nixos-generate-config

# rebuild system
nixos-rebuild switch
