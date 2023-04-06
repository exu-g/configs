#!/usr/bin/env bash
set -euo pipefail

if [ $# -eq 0 ]; then
    echo "Please supply one file"
    $(exit 1)
    echo "$?"
elif [ $# -ge 2 ]; then
    echo "Please only give one argument"
    $(exit 1)
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
    # delimiter @ is used instead of /
    sed -i 's@AllowedIPs = 0.0.0.0/0,::0/0@AllowedIPs = 0.0.0.0/1, 128.0.0.0/3, 160.0.0.0/5, 168.0.0.0/6, 172.0.0.0/12, 172.32.0.0/11, 172.64.0.0/10, 172.128.0.0/9, 173.0.0.0/8, 174.0.0.0/7, 176.0.0.0/4, 192.0.0.0/9, 192.128.0.0/11, 192.160.0.0/13, 192.169.0.0/16, 192.170.0.0/15, 192.172.0.0/14, 192.176.0.0/12, 192.192.0.0/10, 193.0.0.0/8, 194.0.0.0/7, 196.0.0.0/6, 200.0.0.0/5, 208.0.0.0/4, 224.0.0.0/3, ::/1, 8000::/2, c000::/3, e000::/4, f000::/5, f800::/6, fe00::/9, fec0::/10, ff00::/8@g' "$file"
    echo "Patching $file"
done

zip -r -9 "$patched" "vpnconfigs"

rm -rf "$extract"
