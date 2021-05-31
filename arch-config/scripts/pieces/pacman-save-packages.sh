#!/usr/bin/env bash
set -euo pipefail

##################################################
####### Save explicitly installed packages #######
##################################################

echo "Saving explicitly installed packages"

pacman -Qeq > "$HOME/GitProjects/setup/packages/"$(hostname)"-packages.txt"

"$HOME/GitProjects/setup/packages/sort-lists.sh"
