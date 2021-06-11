#!/usr/bin/env bash
set -euo pipefail

# creates an array of all network devices
# NOTE only matches wlp[0-9]s[0-9].* and enp[0-9]s[0-9].*
#readarray -t interfaces < <(ip l | awk -F ":" '/^[0-9]+:/{dev=$2 ; if ( dev !~ /^ lo$/ && dev !~ /^ vmnet.*/) {print $2}}')
readarray -t interfaces < <(ip l | awk -F ":" '/^[0-9]+:/{dev=$2 ; if ( dev ~ /^ wlp[0-9]s[0-9].*$/ || dev ~ /^ enp[0-9]s[0-9].*/) {print $2}}')

# print array
for i in "${interfaces[@]// /}" ; do echo "$i" ; done
