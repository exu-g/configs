#!/bin/bash

i3-msg 'mode "default"'

i3-msg 'workspace 1; exec kitty'

sleep 0.4

i3-msg 'workspace 2; exec firefox'

sleep 1.5

i3-msg 'workspace 2; exec evolution'

sleep 0.5

i3-msg 'workspace 2; exec joplin-desktop'

sleep 0.3

i3-msg 'workspace 2; exec discord'

sleep 7.5

i3-msg 'workspace 2; exec telegram-desktop'

sleep 0.3

i3-msg 'workspace 2; layout tabbed'
