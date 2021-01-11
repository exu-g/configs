#!/bin/bash

set -euo pipefail

#DO NOT MAKE CHANGES TO THE INSTALL SCRIPT HERE. USE arcolinux-config.sh IN ~/scripts FOR THAT

#change to home (does not show in terminal)
cd $HOME

echo Launching arcolinux-config.sh

#make executable & launch arcolinux-config.sh
chmod +x ~/config/scripts/arcolinux-config.sh
bash ~/config/scripts/arcolinux-config.sh
exit 0
