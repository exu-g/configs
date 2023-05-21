#!/usr/bin/env bash
set -euo pipefail

#DO NOT MAKE CHANGES TO THE INSTALL SCRIPT HERE. USE arch-config.sh IN ~/scripts FOR THAT

#change to home (does not show in terminal)
cd $HOME

echo Launching arch-config.sh

#make executable & launch arch-config.sh
chmod +x ~/configs/arch-config/scripts/arch-config.sh
bash ~/configs/arch-config/scripts/arch-config.sh
exit 0
