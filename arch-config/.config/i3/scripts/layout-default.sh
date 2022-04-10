#!/bin/bash

i3-msg 'mode "default"'

i3-msg 'workspace 1; exec kitty'

sleep 0.4

i3-msg 'workspace 2; exec firefox'

sleep 1.7

#i3-msg 'workspace 2; exec evolution'
i3-msg 'workspace 2; exec thunderbird'

sleep 0.5

i3-msg 'workspace 2; exec joplin-desktop'

sleep 0

i3-msg 'workspace 2; exec discord --no-sandbox'

sleep 0.5
# set tabbed layout
i3-msg 'workspace 2; layout tabbed'

#sleep 7.8

#i3-msg 'workspace 2; exec telegram-desktop'
