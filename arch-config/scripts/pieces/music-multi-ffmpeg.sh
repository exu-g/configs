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

    # check if any flac files exist. cancle if that is not the case
    if ls *.flac > /dev/null 2>&1; then
        # get flac files
        ls -f *.flac > "$HOME/MusikRaw/$dir/flaclist"

        # create transcode directory
        mkdir -p "$HOME/MusikRaw/$dir/transcode"


        # convert flac files to opus
        while read -r file; do
            # only set amount of jobs
            while [[ $(jobs | wc -l) -gt $numjobs ]] ; do sleep 1 ; done

            # strip extension
            noextfile="${file%.*}"
            # add opus extension
            opusfile="${noextfile}.opus"
            ffmpeg -nostdin -i "$HOME/MusikRaw/$dir/$file" "$HOME/MusikRaw/$dir/transcode/$opusfile" &
        done < flaclist

        # remove list
        rm "$HOME/MusikRaw/$dir/flaclist"
    fi

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
