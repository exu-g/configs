#!/usr/bin/env bash
set -euo pipefail

if $# -ne 3; then
    echo "Please use this script with \"PATH\" \"Input Extension\" \"Output Extension\""
fi

# TODO argument sanity check

dir=$1
inext=$2
outext=$3
numjobs=4

# go to target dir
cd "$dir"

# select all files
readarray -d '' infiles < <(find . -name "*\.$inext" -print0)

for file in "${infiles[@]}"; do
    # only run $numjobs
    while [[ $(jobs | wc -l) -gt $numjobs ]] ; do sleep 1 ; done
    # filename
    file="$(basename "$file")"
    # no extension
    noextfile="${file%.*}"
    # new extension
    outextfile="${noextfile}.${outext}"
    # actually use ffmpeg
    ffmpeg -nostdin -i "$file" "${outextfile}" &
done

$(exit 0); echo "$?"
