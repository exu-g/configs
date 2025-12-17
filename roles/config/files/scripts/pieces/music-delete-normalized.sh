#!/usr/bin/env bash
set -euo pipefail

find "$HOME/Nextcloud/MusikRaw" -depth -name "normalized" -type d -exec rm -r '{}' \;

echo 'Removed all "normalized" directories and files'
