#!/bin/bash
set -euo pipefail

# change into music raw folder
cd "$HOME/MusikRaw"

# get directories
ls -d */ > directories

while read -r dir; do
    cd "$dir"
    rm -rf normalized
    cd "$HOME/MusikRaw"
done < directories
