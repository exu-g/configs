#!/usr/bin/env bash
set -euo pipefail

# change into music raw folder
cd "$HOME/Nextcloud/MusikRaw"

# get directories
ls -d */ > artistdirectories

while read -r artdir; do
    cd "$artdir"
    # get albums
    ls -d */ > directories
    # delete normalized from albums
    while read -r dir; do
        cd "$dir"
        rm -rf normalized
        cd "$HOME/Nextcloud/MusikRaw/$artdir"
    done < directories
    # cleanup
    rm directories
    cd "$HOME/Nextcloud/MusikRaw"
done < artistdirectories
# cleanup
rm artistdirectories

exit
