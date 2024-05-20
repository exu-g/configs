#!/usr/bin/env bash
set -euo pipefail

##################################################
####### Save explicitly installed packages #######
##################################################

echo "Saving explicitly installed packages"

pacman -Qeq > "$HOME/GitProjects/configs/arch-setup/packages/"$(hostname)"-packages.txt"

"$HOME/GitProjects/configs/arch-setup/packages/sort-lists.sh"
