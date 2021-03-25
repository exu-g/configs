#!/bin/bash

i3-msg 'workspace 1; exec kitty'

i3-msg 'workspace 2; layout tabbed; exec firefox'

i3-msg 'workspace 2; layout tabbed; exec thunderbird'

i3-msg 'workspace 2; layout tabbed; exec discord'

#i3-msg 'workspace 2; layout tabbed; exec element-desktop'

i3-msg 'workspace 2; layout tabbed; exec telegram-desktop'

i3-msg 'mode "default"'
