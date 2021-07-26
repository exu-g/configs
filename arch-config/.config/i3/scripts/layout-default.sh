#!/bin/bash

i3-msg 'mode "default"'

i3-msg 'workspace 1; exec kitty'

sleep 0.4

i3-msg 'workspace 2; layout tabbed'

sleep 0.1

i3-msg 'workspace 2; exec firefox'

sleep 0.9

#i3-msg 'workspace 2; layout tabbed; exec thunderbird'
i3-msg 'workspace 2; exec evolution'

sleep 0.3

i3-msg 'workspace 2; exec discord'

sleep 5.8

#i3-msg 'workspace 2; layout tabbed; exec element-desktop'

i3-msg 'workspace 2; exec telegram-desktop'
