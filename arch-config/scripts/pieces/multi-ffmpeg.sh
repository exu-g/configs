#!/bin/bash
set -euo pipefail

# change into music raw folder
cd "$HOME/MusikRaw"

# number of parallel jobs can be set on as an argument
numjobs="$1"

# get directories
ls -d */ > directories

while read -r dir; do
    # change into directory
    cd "$dir"
    # create directory in music
    mkdir -p "$HOME/Musik/$dir"

    # if there are $numjobs or more, dont spawn any new processes
    while [[ $(jobs | wc -l) -gt $numjobs ]] ; do sleep 1 ; done
    # convert m4a
    if [[ $(ls | grep ".m4a") ]]; then
        ffmpeg-normalize *.m4a -v -pr -c:a libopus -ext opus &
    fi
    # convert flac
    if [[ $(ls | grep ".flac") ]]; then
        ffmpeg-normalize *.flac -v -pr -c:a flac -ext flac &
    fi
    # convert opus
    if [[ $(ls | grep ".opus") ]]; then
        ffmpeg-normalize *.opus -v -pr -c:a libopus -ext opus &
    fi
    # link cover.jpg
    if [[ -f cover.jpg ]]; then
        ln -vf "$HOME/MusikRaw/$dir/cover.jpg" "$HOME/Musik/$dir/"
    fi

    # make symbolic link to music
    ln -svf "$HOME/MusikRaw/$dir/normalized/"* "$HOME/Musik/$dir/"
    # go back to music raw
    cd "$HOME/MusikRaw"
done < directories

# remove directories file
rm directories

echo Finished!

exit
