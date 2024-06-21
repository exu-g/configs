#!/usr/bin/env bash
set -euo pipefail

# You can call this script like this:
# $./dunst-volume.sh up
# $./dunst-volume.sh down
# $./dunst-volume.sh mute

get_volume() {
    amixer -D pipewire get Master | grep '%' | head -n 1 | cut -d '[' -f 2 | cut -d '%' -f 1
}

is_mute() {
    amixer -D pipewire get Master | grep '%' | grep -oE '[^ ]+$' | grep off >/dev/null
}

send_notification() {
    volume=$(get_volume)
    # Send the notification
    dunstify -i audio-volume-high -r 2593 -a volume-script -h int:value:$volume "Volume - ${volume}%"
}

case $1 in
    up)
        # Set the volume on (if it was muted)
        amixer -D pipewire set Master on >/dev/null
        # Up the volume (+ 5%)
        amixer -D pipewire sset Master 5%+ >/dev/null
        send_notification
        ;;
    down)
        amixer -D pipewire set Master on >/dev/null
        amixer -D pipewire sset Master 5%- >/dev/null
        send_notification
        ;;
    mute)
        # Toggle mute
        amixer -D pipewire set Master 1+ toggle >/dev/null
        if is_mute; then
            volume=$(get_volume)
            dunstify -i audio-volume-muted -r 2593 -a volume-script -h int:value:$volume "Mute"
        else
            send_notification
        fi
        ;;
esac
