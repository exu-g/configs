#!/usr/bin/env bash
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
#find "$HOME/MusikRaw/" -name "*\.opus" | grep -v "\/normalized\/" | grep -v "\/transcode\/" > opusfiles

# array of opus with find
readarray -d '' opusfiles < <(find "$HOME/MusikRaw/" -not \( -path *"\/normalized\/"* -prune \) -not \( -path *"\/transcode\/"* -prune \) -name "*\.opus" -print0)

for opus in "${opusfiles[@]}"; do
#while read -r opus; do
    # if there are $numjobs or more, dont spawn any new processes
    while [[ $(jobs | wc -l) -gt $numjobs ]] ; do sleep 1 ; done

    # get directory path
    pathname="$(dirname "$opus")"
    # go to that path for proper output location
    cd "$pathname"
    # convert file
    ffmpeg-normalize "$opus" -v -pr -c:a libopus -b:a 128k -ext opus &
#done < opusfiles
done

# go to musik raw folder
cd "$HOME/MusikRaw"

# cleanup
#rm opusfiles

##############################
#####      M4A           #####
##############################

# find m4a files, ignore "normalized" or "transcode" folders
#find "$HOME/MusikRaw/" -name "*\.m4a" | grep -v "\/normalized\/" | grep -v "\/transcode\/" > m4afiles

# array of m4a with find
readarray -d '' m4afiles < <(find "$HOME/MusikRaw/" -not \( -path *"\/normalized\/"* -prune \) -not \( -path *"\/transcode\/"* -prune \) -name "*\.m4a" -print0)

for m4a in "${m4afiles[@]}"; do
#while read -r m4a; do
    # if there are $numjobs or more, dont spawn any new processes
    while [[ $(jobs | wc -l) -gt $numjobs ]] ; do sleep 1 ; done

    # get directory path
    pathname="$(dirname "$m4a")"
    # go to that path for proper output location
    cd "$pathname"
    # convert file
    ffmpeg-normalize "$m4a" -v -pr -c:a libopus -b:a 128k -ext opus &
#done < m4afiles
done

# go to musik raw folder
cd "$HOME/MusikRaw"

# cleanup
#rm m4afiles

##############################
#####      FLAC          #####
##############################

# find flac files, ignore "normalized" or "transcode" folders
#find "$HOME/MusikRaw/" -name "*\.flac" | grep -v "\/normalized\/" | grep -v "\/transcode\/" > flacfiles

# array of flac with find
readarray -d '' flacfiles < <(find "$HOME/MusikRaw/" -not \( -path *"\/normalized\/"* -prune \) -not \( -path *"\/transcode\/"* -prune \) -name "*\.flac" -print0)

for flac in "${flacfiles[@]}"; do
#while read -r flac; do
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
    ffmpeg -nostdin -i "$flac" -b:a 384k "${pathname}/transcode/$opusfile" &
#done < flacfiles
done

# wait for previous jobs to finish
while [[ $(jobs | wc -l) -gt 1 ]] ; do sleep 1 ; done

cd "$HOME/MusikRaw"

# convert previously transcoded flacs
for flac in "${flacfiles[@]}"; do
#while read -r flac; do
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
    ffmpeg-normalize "transcode/$opusfile" -v -pr -c:a libopus -b:a 384k -ext opus &
#done < flacfiles
done

# go to musik raw folder
cd "$HOME/MusikRaw"

# cleanup
#rm flacfiles

##############################
#####      MP3           #####
##############################

# find mp3 files, ignore "normalized" or "transcode" folders
#find "$HOME/MusikRaw/" -name "*\.mp3" | grep -v "\/normalized\/" | grep -v "\/transcode\/" > mp3files

# array of mp3 with find
readarray -d '' mp3files < <(find "$HOME/MusikRaw/" -not \( -path *"\/normalized\/"* -prune \) -not \( -path *"\/transcode\/"* -prune \) -name "*\.mp3" -print0)

for mp3 in "${mp3files[@]}"; do
#while read -r mp3; do
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
#done < mp3files
done

# wait for previous jobs to finish
while [[ $(jobs | wc -l) -gt 1 ]] ; do sleep 1 ; done

cd "$HOME/MusikRaw"

# convert previously transcoded mp3s
for mp3 in "${mp3files[@]}"; do
#while read -r mp3; do
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
#done < mp3files
done

# go to musik raw folder
cd "$HOME/MusikRaw"

# cleanup
#rm mp3files

############################################################

echo Finished!

$(exit 0); echo "$?"
