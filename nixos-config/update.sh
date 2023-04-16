#!/usr/bin/env sh
set -euo pipefail

git fetch -a
git reset --hard
git clean -fd
git pull
