#!/bin/bash

i3-msg 'workspace 1; exec kitty'

sleep 0.5

i3-msg 'workspace 2; layout tabbed; exec firefox'

sleep 0.5

i3-msg 'workspace 2; layout tabbed; exec thunderbird'

sleep 0.5

i3-msg 'workspace 2; layout tabbed; exec slack'

sleep 0.5

i3-msg 'workspace 2; layout tabbed; exec teams'

sleep 0.5

i3-msg 'workspace 2; layout tabbed; exec p3x-onenote'

sleep 0.5

i3-msg 'mode "default"'
