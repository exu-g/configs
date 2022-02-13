#!/usr/bin/env bash
set -euo pipefail
shopt -s extglob

if [ $# -ne 1 ]; then
    echo "Please use this script with a \"PATH\" to a folder your manga images"
    $(exit 1); echo "$?"
fi

dir=$1

cd "$dir"

out="$(basename "$dir")-cropped"

# create a new directory to put our final cropped images
mkdir -p "../$out"

readarray -d '' images < <(find . -name "*\.jpeg" -print0)

for image in "${images[@]}"; do
    # strip ./ from images and output current working on
    echo "Working on ${image#./}"
    noext="${image%.*}"
    ratio=$(identify -format "%[fx:w/h]" "$image")> /dev/null
    # get the image number
    num=$(echo "$noext" | grep -Eoe [0-9]{3})
    # strip leading 0s
    num="${num##+(0)}"
    # if number is empty (like with 000), set it to 0
    [[ -z "${num}" ]] && num=0
    # images with horizontal orientation
    if (( $(echo "$ratio > 1" | bc -l) )); then
        # check whether image should be double or single paged
        cropwidth=50
        # get image measurements
        width=$(identify -format "%w" "$image")
        height=$(identify -format "%h" "$image")
        left="$(convert "$image" -crop "${cropwidth}"x"${height}"+"$(echo "$width / 2 - $cropwidth" | bc -l)"+0 -resize 1x1\! -format "%[fx:mean]" info:-)"
        right="$(convert "$image" -crop ${cropwidth}x${height}+$(echo "$width / 2" | bc -l)+0 -resize 1x1\! -format "%[fx:mean]" info:-)"
        # if either left or right are above the threshold, split the image
        if (( $(echo "$left > 0.93" | bc -l) )) || (( $(echo "$right > 0.93" | bc -l) )); then
            # crop image in half
            convert -crop 50%x100% "$image" "../$out/$noext-%d.jpeg"
            # rename the -1, which is the first page to the original name
            mv "../$out/$noext-1.jpeg" "../$out/page${num}.jpeg"
            # increment image number
            ((num++))
            # rename -0 to original image + 1 name
            mv "../$out/$noext-0.jpeg" "../$out/page${num}.jpeg"
        # copy double pages
        else
            cp "$image" "../$out/page${num}.jpeg"
        fi
    # images with vertical orientation
    else
        # copy all other images
        cp "$image" "../$out/page${num}.jpeg"
    fi
done

# find average color in an area
# %[fx:int(255*r+.5)]: color value of R-channel
# %[fx:mean]: overall brightness from 0 to 1
# %[fx:mean.r]: brightness from 0 to 1 for R-channel
#convert page001.jpeg -crop (area width)x(area height)+(x-coord top left)+(y-coord to left) -resize 1x1\! -format "%[fx:int(255*r+.5)],%[fx:int(255*g+.5)],%[fx:int(255*b+.5)]" info:-
#convert page001.jpeg -crop 50x1650+1109+0 -resize 1x1\! -format "%[fx:mean],%[fx:mean.r],%[fx:mean.g],%[fx:mean.b]," info:-

# left
#convert page001.jpeg -crop 50x1650+1109+0 -resize 1x1\! -format "%[fx:mean]" info:-
# right
#convert page001.jpeg -crop 50x1650+1159+0 -resize 1x1\! -format "%[fx:mean]" info:-

# crop image to the area specified
#convert page001.jpeg -crop 100x1650+1109+0 page001-test.jpeg

# one crop left and one crop right
# if either one is over the threshold, we split the image
#convert page001.jpeg -crop (crop width)x(image height)+(half image width - crop width)+0 page001-left.jpeg
#convert page001.jpeg -crop (crop width)x(image height)+(half image width)+0 page001-right.jpeg

# some values
# for split, find lower numbers
# to split: 0.969366
# for not split, find highest numbers
# not split: 0.917692
