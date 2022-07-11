#!/usr/bin/env bash
set -euo pipefail

# change into music raw folder
cd "$HOME/MusikRaw"

# number of parallel jobs can be set on as an argument
numjobs="$1"

##############################
#####      OPUS          #####
##############################

# array of opus with find
readarray -d '' opusfiles < <(find "$HOME/MusikRaw/" -not \( -path *"\/normalized\/"* -prune \) -not \( -path *"\/transcode\/"* -prune \) -name "*\.opus" -print0)

for opus in "${opusfiles[@]}"; do
    # if there are $numjobs or more, dont spawn any new processes
    while [[ $(jobs | wc -l) -gt $numjobs ]] ; do sleep 1 ; done

    # get directory path
    pathname="$(dirname "$opus")"
    # go to that path for proper output location
    cd "$pathname"
    # convert file
    ffmpeg-normalize "$opus" -v -pr -c:a libopus -b:a 128k -ext opus &
done

# go to musik raw folder
cd "$HOME/MusikRaw"

##############################
#####      M4A           #####
##############################

# array of m4a with find
readarray -d '' m4afiles < <(find "$HOME/MusikRaw/" -not \( -path *"\/normalized\/"* -prune \) -not \( -path *"\/transcode\/"* -prune \) -name "*\.m4a" -print0)

for m4a in "${m4afiles[@]}"; do
    # if there are $numjobs or more, dont spawn any new processes
    while [[ $(jobs | wc -l) -gt $numjobs ]] ; do sleep 1 ; done

    # get directory path
    pathname="$(dirname "$m4a")"
    # go to that path for proper output location
    cd "$pathname"
    # convert file
    ffmpeg-normalize "$m4a" -v -pr -c:a libopus -b:a 128k -ext opus &
done

# go to musik raw folder
cd "$HOME/MusikRaw"

##############################
#####      FLAC          #####
##############################

# array of flac with find
readarray -d '' flacfiles < <(find "$HOME/MusikRaw/" -not \( -path *"\/normalized\/"* -prune \) -not \( -path *"\/transcode\/"* -prune \) -name "*\.flac" -print0)

for flac in "${flacfiles[@]}"; do
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
    if [ -f "${pathname}/cover.jpg" ]; then
        ffmpeg -nostdin -i "$flac" -i "${pathname}/cover.jpg" -c:a libopus -b:a 384k "${pathname}/transcode/$opusfile" &
    else
        ffmpeg -nostdin -i "$flac" -c:a libopus -b:a 384k "${pathname}/transcode/$opusfile" &
    fi
done

# wait for previous jobs to finish
while [[ $(jobs | wc -l) -gt 1 ]] ; do sleep 1 ; done

cd "$HOME/MusikRaw"

# convert previously transcoded flacs
for flac in "${flacfiles[@]}"; do
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
done

# go to musik raw folder
cd "$HOME/MusikRaw"

##############################
#####      MP3           #####
##############################

# array of mp3 with find
readarray -d '' mp3files < <(find "$HOME/MusikRaw/" -not \( -path *"\/normalized\/"* -prune \) -not \( -path *"\/transcode\/"* -prune \) -name "*\.mp3" -print0)

for mp3 in "${mp3files[@]}"; do
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
    if [ -f "${pathname}/cover.jpg" ]; then
        ffmpeg -nostdin -i "$mp3" -i "${pathname}/cover.jpg" -c:a libopus -b:a 192k "${pathname}/transcode/$opusfile" &
    else
        ffmpeg -nostdin -i "$mp3" -c:a libopus -b:a 192k "${pathname}/transcode/$opusfile" &
    fi
done

# wait for previous jobs to finish
while [[ $(jobs | wc -l) -gt 1 ]] ; do sleep 1 ; done

cd "$HOME/MusikRaw"

# convert previously transcoded mp3s
for mp3 in "${mp3files[@]}"; do
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
done

# go to musik raw folder
cd "$HOME/MusikRaw"

##############################
#####      WAV           #####
##############################

# array of wav with find
readarray -d '' wavfiles < <(find "$HOME/MusikRaw/" -not \( -path *"\/normalized\/"* -prune \) -not \( -path *"\/transcode\/"* -prune \) -name "*\.wav" -print0)

for wav in "${wavfiles[@]}"; do
    # if there are $numjobs or more, dont spawn any new processes
    while [[ $(jobs | wc -l) -gt $numjobs ]] ; do sleep 1 ; done

    # get directory path
    pathname="$(dirname "$wav")"
    # go to that path for proper output location
    cd "$pathname"
    # create directory for transcodes
    mkdir -p "$pathname/transcode"
    # get name of file
    file="$(basename "$wav")"
    # strip extension
    noextfile="${file%.*}"
    # add opus extension
    opusfile="${noextfile}.opus"

    # convert to opus in transcode directory
    if [ -f "${pathname}/cover.jpg" ]; then
        ffmpeg -nostdin -i "$wav" -i "${pathname}/cover.jpg" -c:a libopus -b:a 384k "${pathname}/transcode/$opusfile" &
    else
        ffmpeg -nostdin -i "$wav" -c:a libopus -b:a 384k "${pathname}/transcode/$opusfile" &
    fi
done

# wait for previous jobs to finish
while [[ $(jobs | wc -l) -gt 1 ]] ; do sleep 1 ; done

cd "$HOME/MusikRaw"

# convert previously transcoded wavs
for wav in "${wavfiles[@]}"; do
    # if there are $numjobs or more, dont spawn any new processes
    while [[ $(jobs | wc -l) -gt $numjobs ]] ; do sleep 1 ; done

    # get directory path
    pathname="$(dirname "$wav")"
    # go to that path for proper output location
    cd "$pathname"
    # get name of file
    file="$(basename "$wav")"
    # strip extension
    noextfile="${file%.*}"
    # add opus extension
    opusfile="${noextfile}.opus"

    # convert opus in transcode to normalized
    ffmpeg-normalize "transcode/$opusfile" -v -pr -c:a libopus -b:a 384k -ext opus &
done

# go to musik raw folder
cd "$HOME/MusikRaw"

while [[ $(jobs | wc -l) -gt 1 ]] ; do sleep 1 ; done

echo Finished!

exit 0
