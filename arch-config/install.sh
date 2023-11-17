#!/usr/bin/env bash
set -euo pipefail

#DO NOT MAKE CHANGES TO THE INSTALL SCRIPT HERE. USE arch-config.sh IN ~/scripts FOR THAT

# get script directory
scriptloc="$BASH_SOURCE"
configdir=$(dirname "$scriptloc")

echo Launching arch-config.sh

#make executable & launch arch-config.sh
chmod +x "$configdir/scripts/arch-config.sh"
bash "$configdir/scripts/arch-config.sh"
exit 0
