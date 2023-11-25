#!/usr/bin/env bash
set -euo pipefail

# remove content of music directory
rm -rf "$HOME/Musik/"*

# change into music raw folder
cd "$HOME/Nextcloud/MusikRaw"

# get directories
ls -d */ > artistdirectories

while read -r artdir; do
    cd "$artdir"
    # get albums
    ls -d */ > directories
    while read -r dir; do
        # change into directory
        cd "$dir"
        # create directory in music
        mkdir -p "$HOME/Musik/${artdir}/$dir"

        # link cover image (jpg or png)
        if [ -f cover.jpg ]; then
            ln -vf "$HOME/Nextcloud/MusikRaw/${artdir}/$dir/cover.jpg" "$HOME/Musik/${artdir}/$dir/"
        elif [ -f cover.png ]; then
            ln -vf "$HOME/Nextcloud/MusikRaw/${artdir}/$dir/cover.png" "$HOME/Musik/${artdir}/$dir/"
        fi

        # make symbolic link to music
        # if the "normalized" directory exists, links are created
        if [ -d "normalized" ]; then
            ln -svf "$HOME/Nextcloud/MusikRaw/${artdir}/$dir/normalized/"* "$HOME/Musik/${artdir}/$dir/"
        fi

        # go back to music raw
        cd "$HOME/Nextcloud/MusikRaw/$artdir"
    done < directories
    # cleanup
    rm directories
    cd "$HOME/Nextcloud/MusikRaw"
done < artistdirectories
# cleanup
rm artistdirectories

echo Finished!

exit
