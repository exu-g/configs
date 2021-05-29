#!/usr/bin/env bash
set -euo pipefail

if [ $# -eq 0 ]; then
    echo "Please supply one file"
    $(exit 1); echo "$?"
elif [ $# -ge 2 ]; then
    echo "Please only give one argument"
    $(exit 1); echo "$?"
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
    if grep "PostUp" "$file" &>/dev/null; then
        echo "Skipping $file"
    else
        echo "Patching $file"
        awk 'NR==5{print "PostUp = ip route add 192.168.1.0/24 via 172.16.52.1"}NR==5{print "PreDown = ip route delete 192.168.1.0/24;"}1' "$file" > "${file}.tmp"
        mv "${file}.tmp" "$file"
    fi
done

zip -r -9 "$patched" "vpnconfigs"

rm -rf "$extract"
