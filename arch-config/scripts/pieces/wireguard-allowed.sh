#!/usr/bin/env bash
set -euo pipefail

if [ $# -eq 0 ]; then
    echo "Please supply one file"
    exit 1
    echo "$?"
elif [ $# -ge 2 ]; then
    echo "Please only give one argument"
    exit 1
    echo "$?"
fi

cd "$HOME"

file="$1"
parent="$(dirname "$file")"
extract="${parent}/vpnconfigs"
patched="${file%.*}-patched.zip"

cd "$parent"

mkdir -p "${parent}/vpnconfigs"

unzip "$file" -d "$extract"

readarray -d '' conffiles < <(find "$extract" -name "*\.conf" -print0)

for file in "${conffiles[@]}"; do
    echo "Patching $file"
    endpointIP="$(grep "Endpoint =" "$file" | grep -Eo "[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}")"
    echo "Calculating AllowedIPs"
    allowedIPs="$(~/GitProjects/configs/arch-config/scripts/pieces/ipexclude.py -e "$endpointIP" -e 172.16.0.0/12 -e 162.55.10.16/32)"
    echo "Replacing AllowedIPs"
    # delimiter @ is used instead of /
    sed -i "s@AllowedIPs = 0.0.0.0/0,::0/0@AllowedIPs = $allowedIPs@g" "$file"
    echo "Removing DNS"
    sed -i 's/DNS = 10.64.0.1//g' "$file"
    echo "Finished $file"
done

zip -r -9 "$patched" "vpnconfigs"

rm -rf "$extract"
