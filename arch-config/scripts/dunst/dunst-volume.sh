#!/usr/bin/env bash

set -euo pipefail

# You can call this script like this:
# $./dunst-volume.sh up
# $./dunst-volume.sh down
# $./dunst-volume.sh mute

get_volume() {
    amixer -D pulse get Master | grep '%' | head -n 1 | cut -d '[' -f 2 | cut -d '%' -f 1
}

is_mute() {
    amixer -D pulse get Master | grep '%' | grep -oE '[^ ]+$' | grep off >/dev/null
}

send_notification() {
    # Make the bar with the special character ─ (it's not dash -)
    # https://en.wikipedia.org/wiki/Box-drawing_character
    #bar=$(seq -s "─" $(($volume / 5)) | sed 's/[0-9]//g')
    # Send the notification
    #dunstify -i audio-volume-high -r 2593 -a volume-script "$volume    $bar    "
    dunstify -i audio-volume-high -a volume-script -h int:value:$volume "Volume"
}


volume=$(get_volume)

case $1 in
    up)
        send_notification
        # Set the volume on (if it was muted)
        amixer -D pipewire set Master on >/dev/null
        # Up the volume (+ 5%)
        amixer -D pipewire sset Master 5%+ >/dev/null
        ;;
    down)
        send_notification
        amixer -D pipewire set Master on >/dev/null
        amixer -D pipewire sset Master 5%- >/dev/null
        ;;
    mute)
        if is_mute; then
            dunstify -i audio-volume-muted -a volume-script -h int:value:$volume "Mute"
        else
            send_notification
        fi
        # Toggle mute
        amixer -D pipewire set Master 1+ toggle >/dev/null
        ;;
esac
