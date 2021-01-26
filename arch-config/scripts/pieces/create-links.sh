#!/usr/bin/env bash
set -euo pipefail

# remove content of music directory
rm -rf "$HOME/Musik/"*

# change into music raw folder
cd "$HOME/MusikRaw"

# get directories
ls -d */ > directories

while read -r dir; do
    # change into directory
    cd "$dir"
    # create directory in music
    mkdir -p "$HOME/Musik/$dir"

    # link cover.jpg
    if [[ -f cover.jpg ]]; then
        ln -vf "$HOME/MusikRaw/$dir/cover."* "$HOME/Musik/$dir/"
    fi

    # make symbolic link to music
    # if the "normalized" directory exists, links are created
    if [[ -d "normalized" ]]; then
        ln -svf "$HOME/MusikRaw/$dir/normalized/"* "$HOME/Musik/$dir/"
    fi
    # go back to music raw
    cd "$HOME/MusikRaw"
done < directories

# remove directories file
rm directories

echo Finished!

exit
