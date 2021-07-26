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

sleep 2

#i3-msg 'workspace 2; layout tabbed; exec slack'

#sleep 0.5

i3-msg 'workspace 2; exec teams'

sleep 1

i3-msg 'workspace 2; exec p3x-onenote'
