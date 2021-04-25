#!/usr/bin/env bash
set -euo pipefail

# { time tar -c -I"zstd -19 -T0" -f polybar-themes2.tar.zst polybar-themes/ ; } 2> result

# read working directory
workdir="$1"

cd "$workdir"

cd ..

if [[ -f compression-results.txt ]]; then
    rm compression-results.txt
fi

# run compression with 4 threads
for i in {1..19}; do
    for x in {1..5}; do
        # remove previous round
        if [[ -f zstd-$i.tar.zst ]]; then
            rm zstd-$i.tar.zst
        fi
        echo "zstd -$i -T4: Run $x" >> compression-results.txt
        { time tar -c -I"zstd -$i -T4" -f zstd-$i.tar.zst "$workdir" 2> /dev/null ; } 2>>  compression-results.txt
        echo "-----------------------------" >> compression-results.txt
        echo "Finished Run $x with zstd -$i -T4"
    done
done
