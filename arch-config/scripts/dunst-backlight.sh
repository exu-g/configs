#!/bin/bash

# You can call this script like this:
# $./dunst-backlight.sh up
# $./dunst-backlight.sh down

: '
get_light() {
    xbacklight -get | cut -f1 -d"."
}
'

send_notification() {
    light=$(get_light)
    # Make the bar with the special character ─ (it's not dash -)
    # https://en.wikipedia.org/wiki/Box-drawing_character
    bar=$(seq -s "─" $(($light/ 5)) | sed 's/[0-9]//g')
    # Send the notification
    dunstify -i whitebalance -r 2489 -a backlight-script "    $bar    "
}

case $1 in
    up)
    # Increase backlight
    xbacklight -inc 10 > /dev/null
    #xbacklight -inc 10% > /dev/null # legacy xorg-xbacklight
    send_notification
    #backlightraw=$(xbacklight -get)
    #backlight=${backlightraw::-8}
    #xbacklight -set "${backlight}0"
	;;
    down)
    # Decrease backlight
    #xbacklight -dec 9% > /dev/null # legacy xorg-xbacklight
    send_notification
    #backlightraw=$(xbacklight -get)
    #backlight=${backlightraw::-8}
    #xbacklight -set "${backlight}0"
	;;
esac
