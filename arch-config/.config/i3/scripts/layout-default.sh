#!/bin/bash

i3-msg 'workspace 1; exec termite'

i3-msg 'workspace 3; exec liferea'

i3-msg 'workspace 2; layout tabbed; exec firefox'

i3-msg 'workspace 2; layout tabbed; exec thunderbird'

i3-msg 'workspace 2; layout tabbed; exec discord'

i3-msg 'workspace 2; layout tabbed; exec mirage'

i3-msg 'workspace 2; layout tabbed; exec bettergram'

i3-msg 'mode "default"'