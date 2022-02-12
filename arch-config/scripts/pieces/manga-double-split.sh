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
    [[ -z "${num}" ]] && num=0
    if (( $(echo "$ratio > 1" |bc -l) )); then
        # crop image in half
        convert -crop 50%x100% "$image" "../$out/$noext-%d.jpeg"
        # rename the -1, which is the first page to the original name
        mv "../$out/$noext-1.jpeg" "../$out/page${num}.jpeg"
        # increment image number
        ((num++))
        # rename -0 to original image + 1 name
        mv "../$out/$noext-0.jpeg" "../$out/page${num}.jpeg"
    else
        # move all other images
        mv "$image" "../$out/page${num}.jpeg"
    fi
done
