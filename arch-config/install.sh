#!/bin/bash

set -euo pipefail

#DO NOT MAKE CHANGES TO THE INSTALL SCRIPT HERE. USE arcolinux-config.sh IN ~/scripts FOR THAT

#change to home (does not show in terminal)
cd $HOME

echo Launching arch-config.sh

#make executable & launch arch-config.sh
chmod +x ~/config/scripts/arch-config.sh
bash ~/config/scripts/arch-config.sh
exit 0
