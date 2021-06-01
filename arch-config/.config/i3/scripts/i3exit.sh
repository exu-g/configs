#!/bin/sh


case "$1" in
    lock)
        betterlockscreen -l; dunstctl set-paused true
        ;;
    logout)
        i3-msg exit
        ;;
    suspend)
        #betterlockscreen -s
        systemctl suspend
        ;;
    hibernate)
        systemctl hibernate
        ;;
    reboot)
        systemctl reboot
        ;;
    shutdown)
        systemctl poweroff
        ;;
    *)
        echo "Usage: $0 {lock|logout|suspend|hibernate|reboot|shutdown}"
        exit 2
esac

exit 0
