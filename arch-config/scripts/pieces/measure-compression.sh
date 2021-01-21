#!/usr/bin/env bash
set -euo pipefail

# { time tar -c -I"zstd -19 -T0" -f polybar-themes2.tar.zst polybar-themes/ ; } 2> result

# read working directory
workdir="$1"

if [[ -f compression-results.txt ]]; then
    rm compression-results.txt
fi

echo "zstd -1 -T0" >> compression-results.txt
{ time tar -c -I"zstd -1 -T0" -f zstd-1.tar.zst "$workdir" 2> /dev/null ; } 2>>  compression-results.txt
echo "-----------------------------" >> compression-results.txt

echo "zstd -2 -T0" >> compression-results.txt
{ time tar -c -I"zstd -2 -T0" -f zstd-2.tar.zst "$workdir" 2> /dev/null ; } 2>>  compression-results.txt
echo "-----------------------------" >> compression-results.txt

echo "zstd -3 -T0" >> compression-results.txt
{ time tar -c -I"zstd -3 -T0" -f zstd-3.tar.zst "$workdir" 2> /dev/null ; } 2>>  compression-results.txt
echo "-----------------------------" >> compression-results.txt

echo "zstd -4 -T0" >> compression-results.txt
{ time tar -c -I"zstd -4 -T0" -f zstd-4.tar.zst "$workdir" 2> /dev/null ; } 2>>  compression-results.txt
echo "-----------------------------" >> compression-results.txt

echo "zstd -5 -T0" >> compression-results.txt
{ time tar -c -I"zstd -5 -T0" -f zstd-5.tar.zst "$workdir" 2> /dev/null ; } 2>>  compression-results.txt
echo "-----------------------------" >> compression-results.txt
