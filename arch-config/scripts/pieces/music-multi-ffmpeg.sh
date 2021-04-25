#!/bin/bash
set -euo pipefail

# change into music raw folder
cd "$HOME/MusikRaw"

# number of parallel jobs can be set on as an argument
numjobs="$1"

# using find to get music that has to be transcoded

############################################################

##############################
#####      OPUS          #####
##############################

# find opus, ignore anything in "normalized" or "transcode" folders
find "$HOME/MusikRaw/" -name "*\.opus" | grep -v "\/normalized\/" | grep -v "\/transcode\/" > opusfiles

while read -r opus; do
    # if there are $numjobs or more, dont spawn any new processes
    while [[ $(jobs | wc -l) -gt $numjobs ]] ; do sleep 1 ; done

    # get directory path
    pathname="$(dirname "$opus")"
    # go to that path for proper output location
    cd "$pathname"
    # convert file
    ffmpeg-normalize "$opus" -v -pr -c:a libopus -b:a 128k -ext opus &
done < opusfiles

# go to musik raw folder
cd "$HOME/MusikRaw"

# cleanup
rm opusfiles

##############################
#####      M4A           #####
##############################

# find m4a files, ignore "normalized" or "transcode" folders
find "$HOME/MusikRaw/" -name "*\.m4a" | grep -v "\/normalized\/" | grep -v "\/transcode\/" > m4afiles

while read -r m4a; do
    # if there are $numjobs or more, dont spawn any new processes
    while [[ $(jobs | wc -l) -gt $numjobs ]] ; do sleep 1 ; done

    # get directory path
    pathname="$(dirname "$m4a")"
    # go to that path for proper output location
    cd "$pathname"
    # convert file
    ffmpeg-normalize "$m4a" -v -pr -c:a libopus -b:a 128k -ext opus &
done < m4afiles

# go to musik raw folder
cd "$HOME/MusikRaw"

# cleanup
rm m4afiles

##############################
#####      FLAC          #####
##############################

# find flac files, ignore "normalized" or "transcode" folders
find "$HOME/MusikRaw/" -name "*\.flac" | grep -v "\/normalized\/" | grep -v "\/transcode\/" > flacfiles

while read -r flac; do
    # if there are $numjobs or more, dont spawn any new processes
    while [[ $(jobs | wc -l) -gt $numjobs ]] ; do sleep 1 ; done

    # get directory path
    pathname="$(dirname "$flac")"
    # go to that path for proper output location
    cd "$pathname"
    # create directory for transcodes
    mkdir -p "$pathname/transcode"
    # get name of file
    file="$(basename "$flac")"
    # strip extension
    noextfile="${file%.*}"
    # add opus extension
    opusfile="${noextfile}.opus"

    # convert to opus in transcode directory
    # TODO include cover picture (prefer file picture, cover.jpg second preference)
    ffmpeg -nostdin -i "$flac" -b:a 256k "${pathname}/transcode/$opusfile" &
done < flacfiles

# wait for previous jobs to finish
while [[ $(jobs | wc -l) -gt 1 ]] ; do sleep 1 ; done

cd "$HOME/MusikRaw"

# convert previously transcoded flacs
while read -r flac; do
    # if there are $numjobs or more, dont spawn any new processes
    while [[ $(jobs | wc -l) -gt $numjobs ]] ; do sleep 1 ; done

    # get directory path
    pathname="$(dirname "$flac")"
    # go to that path for proper output location
    cd "$pathname"
    # get name of file
    file="$(basename "$flac")"
    # strip extension
    noextfile="${file%.*}"
    # add opus extension
    opusfile="${noextfile}.opus"

    # convert opus in transcode to normalized
    ffmpeg-normalize "transcode/$opusfile" -v -pr -c:a libopus -b:a 256k -ext opus &
done < flacfiles

# go to musik raw folder
cd "$HOME/MusikRaw"

# cleanup
rm flacfiles

##############################
#####      MP3           #####
##############################

# find mp3 files, ignore "normalized" or "transcode" folders
find "$HOME/MusikRaw/" -name "*\.mp3" | grep -v "\/normalized\/" | grep -v "\/transcode\/" > mp3files

while read -r mp3; do
    # if there are $numjobs or more, dont spawn any new processes
    while [[ $(jobs | wc -l) -gt $numjobs ]] ; do sleep 1 ; done

    # get directory path
    pathname="$(dirname "$mp3")"
    # go to that path for proper output location
    cd "$pathname"
    # create directory for transcodes
    mkdir -p "$pathname/transcode"
    # get name of file
    file="$(basename "$mp3")"
    # strip extension
    noextfile="${file%.*}"
    # add opus extension
    opusfile="${noextfile}.opus"

    # convert to opus in transcode directory
    # TODO include cover picture (prefer file picture, cover.jpg second preference)
    ffmpeg -nostdin -i "$mp3" -b:a 192k "${pathname}/transcode/$opusfile" &
done < mp3files

# wait for previous jobs to finish
while [[ $(jobs | wc -l) -gt 1 ]] ; do sleep 1 ; done

cd "$HOME/MusikRaw"

# convert previously transcoded mp3s
while read -r mp3; do
    # if there are $numjobs or more, dont spawn any new processes
    while [[ $(jobs | wc -l) -gt $numjobs ]] ; do sleep 1 ; done

    # get directory path
    pathname="$(dirname "$mp3")"
    # go to that path for proper output location
    cd "$pathname"
    # get name of file
    file="$(basename "$mp3")"
    # strip extension
    noextfile="${file%.*}"
    # add opus extension
    opusfile="${noextfile}.opus"

    # convert opus in transcode to normalized
    ffmpeg-normalize "transcode/$opusfile" -v -pr -c:a libopus -b:a 192k -ext opus &
done < mp3files

# go to musik raw folder
cd "$HOME/MusikRaw"

# cleanup
rm mp3files

############################################################

echo Finished!

exit
