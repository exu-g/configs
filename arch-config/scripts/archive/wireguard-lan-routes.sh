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

#https://www.procustodibus.com/blog/2021/03/wireguard-allowedips-calculator/
#allowedips="0.0.0.0/1, 128.0.0.0/3, 160.0.0.0/7, 162.0.0.0/11, 162.32.0.0/12, 162.48.0.0/14, 162.52.0.0/15, 162.54.0.0/16, 162.55.0.0/21, 162.55.8.0/23, 162.55.10.0/28, 162.55.10.17/32, 162.55.10.18/31, 162.55.10.20/30, 162.55.10.24/29, 162.55.10.32/27, 162.55.10.64/26, 162.55.10.128/25, 162.55.11.0/24, 162.55.12.0/22, 162.55.16.0/20, 162.55.32.0/19, 162.55.64.0/18, 162.55.128.0/17, 162.56.0.0/13, 162.64.0.0/10, 162.128.0.0/9, 163.0.0.0/8, 164.0.0.0/6, 168.0.0.0/5, 176.0.0.0/4, 192.0.0.0/2, ::/0"

for file in "${conffiles[@]}"; do
    # NOTE using "@" as delimiter for sed, as the string "allowedips" contains slashes
    #sed -i "s@\(AllowedIPs\s=\s\)\(.*\)@\1${allowedips}@" "$file"
    if grep "PostUp" "$file" &>/dev/null; then
        echo "Skipping $file"
    else
        echo "Patching $file"
        # NOTE route while being connected into my lan
        awk 'NR==5{print "PostUp = ip route add 192.168.1.0/24 via 172.16.7.1 metric 10"}NR==5{print "PreDown = ip route del 192.168.1.0/24"}1' "$file" > "${file}.tmp"
        mv "${file}.tmp" "$file"
        # hetzner net
        awk 'NR==5{print "PostUp = ip route add 172.18.50.0/24 via 172.16.7.1 metric 10"}NR==5{print "PreDown = ip route del 172.18.50.0/24"}1' "$file" > "${file}.tmp"
        mv "${file}.tmp" "$file"
        # lan1dmz net
        awk 'NR==5{print "PostUp = ip route add 172.16.11.0/24 via 172.16.7.1 metric 10"}NR==5{print "PreDown = ip route del 172.16.11.0/24"}1' "$file" > "${file}.tmp"
        mv "${file}.tmp" "$file"
        # hetzner storage box
        awk 'NR==5{print "PostUp = ip route add 162.55.10.16/32 via 172.16.7.1 metric 10"}NR==5{print "PreDown = ip route del 162.55.10.16/32"}1' "$file" > "${file}.tmp"
        mv "${file}.tmp" "$file"
        # NOTE only one PreDown line is required as we are using a specific table for this
        # TODO tables do not work as intended
        #awk 'NR==5{print "PostUp = ip route add 192.168.1.0/24 via 192.168.86.1 metric 10 table 7"}NR==5{print "PreDown = ip route flush table 7"}1' "$file" > "${file}.tmp"
        # NOTE adds a dns to all configs
        #awk 'NR==4{print "DNS = 172.16.16.5"}1' "$file" > "${file}.tmp"
        #mv "${file}.tmp" "$file"
        # NOTE adds a dns to all configs
        #awk 'NR==5{print "DNS = 172.16.52.5"}1' "$file" > "${file}.tmp"
        #mv "${file}.tmp" "$file"
        # NOTE adds a dns to all configs
        #awk 'NR==6{print "DNS = 172.16.16.1"}1' "$file" > "${file}.tmp"
        #mv "${file}.tmp" "$file"
        # wifi
        #awk 'NR==6{print "PostUp = ip route add 192.168.1.0/24 via 172.16.52.1 metric 20 table 7"}1' "$file" > "${file}.tmp"
        #mv "${file}.tmp" "$file"
    fi
done

zip -r -9 "$patched" "vpnconfigs"

rm -rf "$extract"
