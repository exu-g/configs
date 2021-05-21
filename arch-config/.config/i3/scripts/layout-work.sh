#!/bin/bash

i3-msg 'mode "default"'

i3-msg 'workspace 1; exec kitty'

sleep 0.4

i3-msg 'workspace 2; layout tabbed; exec firefox'

sleep 0.3

#i3-msg 'workspace 2; layout tabbed; exec thunderbird'
i3-msg 'workspace 2; layout tabbed; exec evolution'

sleep 2

i3-msg 'workspace 2; layout tabbed; exec slack'

sleep 0.5

i3-msg 'workspace 2; layout tabbed; exec teams'

sleep 1

i3-msg 'workspace 2; layout tabbed; exec p3x-onenote'

