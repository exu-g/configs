#!/usr/bin/env sh

case "$1" in
    lock)
        swaylock -f -e -i "$HOME/.cache/backgrounds/lockscreen"
        ;;
    logout)
        swaymsg exit
        ;;
    suspend)
        systemctl suspend
        ;;
    hibernate)
        exit 1
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
