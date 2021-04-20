#!/bin/bash

i3-msg 'mode "default"'

i3-msg 'workspace 1; exec kitty'

sleep 0.4

i3-msg 'workspace 2; layout tabbed; exec firefox'

sleep 0.3

i3-msg 'workspace 2; layout tabbed; exec thunderbird'

sleep 0.3

i3-msg 'workspace 2; layout tabbed; exec discord'

sleep 5.7

#i3-msg 'workspace 2; layout tabbed; exec element-desktop'

i3-msg 'workspace 2; layout tabbed; exec telegram-desktop'
