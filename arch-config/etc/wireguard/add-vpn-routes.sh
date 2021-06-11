#!/usr/bin/env bash
set -euo pipefail

# creates an array of all network devices
# NOTE only matches wlp[0-9]s[0-9].* and enp[0-9]s[0-9].*
#readarray -t interfaces < <(ip l | awk -F ":" '/^[0-9]+:/{dev=$2 ; if ( dev !~ /^ lo$/ && dev !~ /^ vmnet.*/) {print $2}}')
readarray -t interfaces < <(ip l | awk -F ":" '/^[0-9]+:/{dev=$2 ; if ( dev ~ /^ wlp[0-9]s[0-9].*$/ || dev ~ /^ enp[0-9]s[0-9].*/ ) {print $2}}')

# print array
#for i in "${interfaces[@]// /}" ; do echo "$i" ; done

# regex for ipv4 addresses
#ip -o address show dev enp5s0 | grep -Eo "([0-9]{1,3}\.){3}[0-9]{1,3}\/[0-9]{1,2}"

# metric to distinguish the routes
metric=10

# loop over all interfaces
for int in "${interfaces[@]// /}"; do
    intipf=`ip -o address show dev "$int" | grep -Eo "([0-9]{1,3}\.){3}[0-9]{1,3}\/[0-9]{1,2}"`
    #echo $intipf
    if [[ $int == "enp"* && $intipf =~ "172.16.52." ]]; then
        #echo lan
        ip route add 192.168.1.0/24 via 172.16.52.1 metric $metric
        # add 10 for next metric
        metric=$(($metric + 10))
    elif [[ $int == "wlp"* && $intipf =~ "192.168.86." ]]; then
        #echo wlan
        ip route add 192.168.1.0/24 via 192.168.86.1 metric $metric
        # add 10 for next metric
        metric=$(($metric + 10))
    fi
done
