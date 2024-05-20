#!/usr/bin/env bash
set -euo pipefail

if [ $# -eq 0 ]; then
    echo "Please supply the seed"
    $(exit 1); echo "$?"
elif [ $# -ge 2 ]; then
    echo "Please only give one argument"
    $(exit 1); echo "$?"
fi

seed="$1"
downloadpath="$HOME/Downloads/thisanimedoesnotexist/${seed}"
creativity=(0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0 1.1 1.2 1.3 1.4 1.5 1.6 1.7 1.8 1.9 2.0)

mkdir -p "$downloadpath"

cd "$downloadpath"

for creativity in "${creativity[@]}"; do
    wget -O - https://thisanimedoesnotexist.ai/results/psi-${creativity}/seed${seed}.png > seed${seed}-${creativity}.png
done

exit
