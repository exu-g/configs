#!/usr/bin/env bash
set -euo pipefail

if [ $# -ne 1 ]; then
    echo "Please use this script with a \"PATH\" to a folder containing Manga chapters"
    $(exit 1); echo "$?"
fi

dir=$1

cd "$dir"

# "-not -name \." so the top directory isn't shown
readarray -d '' chapters < <(find . -type d -not -name \. -print0)

for directory in "${chapters[@]}"; do
    echo $directory
    zip -9 -r "$directory.zip" "$directory"
    mv "$directory.zip" "$directory.cbz"
done
