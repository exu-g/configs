#!/usr/bin/env bash
set -euo pipefail

if [ $# -ne 1 ]; then
    echo "Please provide the path to one video file"
    $(exit 1); echo "$?"
fi

echo "Getting black screen times"

# reads the output of ffprobe into an array
mapfile -t timings < <(ffprobe -f lavfi -i "movie=$1,blackdetect[out0]" -show_entries frame_tags=lavfi.black_start,lavfi.black_end -of default=nw=1 -v quiet -print_format flat)

#timings=(frames.frame.0.tags.lavfi_black_start="0.389" frames.frame.1.tags.lavfi_black_end="0.431" frames.frame.255.tags.lavfi_black_start="11.025" frames.frame.256.tags.lavfi_black_end="11.067")

seltimings=()

for i in "${!timings[@]}"; do
    # cut timing to only output the time
    timing="$(echo ${timings[$i]} | cut -d= -f2 | tr -d '"')"
    if [ $((${i}%2)) -eq 0 ]; then
        starttime=$timing
        #echo "Start time: $starttime"
    else
        endtime=$timing
        #echo "End time: $endtime"
        timediff="$(echo "(($endtime - $starttime))" | bc -l)"
        #echo "Difference: $timediff"
        # check for sections longer than 2 seconds
        if (( $(echo "$timediff > 2" | bc -l) )); then
            echo "Start time: $starttime"
            echo "End time: $endtime"
            echo "Difference: $timediff"
            seltimings+=($starttime)
            seltimings+=($endtime)
        fi
    fi
done

for i in "${seltimings[@]}"; do
    echo $i
done

# track split files created
splitfiles=()

# build command
command="ffmpeg -i "$1" -c copy -map 0 -t ${seltimings[0]} "1.mkv""
splitfiles+=("1.mkv")
echo "file 1.mkv" > "list.txt"

tmp=$(( ${#seltimings[@]} - 2 ))
length=$(( $tmp / 2 ))

selector=1

n=0

while [[ $n -lt $length ]]; do
    n=$((n+1))
    up=$(( $selector + 1 ))
    low=$selector
    command+=" -c copy -map 0 -ss ${seltimings[$low]} -t $(echo "${seltimings[$up]} - ${seltimings[$low]}" | bc -l) "$(( $n + 1 )).mkv""
    splitfiles+=("$(( $n + 1 )).mkv")
    echo "file $(( $n + 1 )).mkv" >> "list.txt"
    selector=$(( $selector + 2 ))
done

lastsel=$(( ${#seltimings[@]} - 1 ))
command+=" -c copy -map 0 -ss ${seltimings[$lastsel]} "$(( $n + 2 )).mkv""
splitfiles+=("$(( $n + 2 )).mkv")
echo "file $(( $n + 2)).mkv" >> "list.txt"

echo "Running command"
echo "$command" | tee command.sh
bash command.sh

ffmpeg -f concat -i "list.txt" -c copy -map 0 "out-${1}"

# cleanup
rm command.sh
rm list.txt
for file in ${splitfiles[@]}; do
    rm "$file"
done

exit 0
