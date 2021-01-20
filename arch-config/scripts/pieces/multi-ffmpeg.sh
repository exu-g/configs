#!/bin/bash
set -euo pipefail

# change into music raw folder
cd "$HOME/MusikRaw"

# number of parallel jobs can be set on as an argument
numjobs="$1"

# get directories
ls -d */ > directories

while read -r dir; do
    #echo "$dir"
    # if there are $numjobs or more, dont spawn any new processes
    while [[ $(jobs | wc -l) -gt $numjobs ]] ; do sleep 1 ; done
    cd "$dir"
    # convert m4a
    if [[ $(ls | grep ".m4a") ]]; then
        ffmpeg-normalize *.m4a -v -pr -c:a libopus -ar 92 -ext opus &
    fi
    # convert flac
    if [[ $(ls | grep ".flac") ]]; then
        ffmpeg-normalize *.flac -v -pr -c:a flac -ar 88.2 -ext flac &
    fi
    # convert opus
    if [[ $(ls | grep ".opus") ]]; then
        ffmpeg-normalize *.opus -v -pr -c:a libopus -ar 92 -ext opus &
    fi
    cd "$HOME/MusikRaw"
    # create directory
    mkdir -p "$HOME/Musik/$dir"
    # make symbolic link to music
    ln -svf "$HOME/MusikRaw/$dir/normalized/"* "$HOME/Musik/$dir/"
done < directories

# remove directories file
rm directories

echo Finished!

exit
