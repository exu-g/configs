#!/usr/bin/env bash
set -euo pipefail

# see how many routes to 192.168.1.0/24 there are
num=`ip route | grep -o 192.168.1.0/24 | wc -l`

# used for loop
runs=0

# loop until you reach the number of routes
# remove each route
while [ $runs -lt $num ]; do
    ip route del 192.168.1.0/24
    runs=$(($runs + 1))
done
