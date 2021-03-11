#!/bin/bash

i3-msg 'workspace 1; exec termite'

i3-msg 'workspace 2; layout tabbed; exec firefox'

i3-msg 'workspace 2; layout tabbed; exec thunderbird'

i3-msg 'workspace 2; layout tabbed; exec slack'

i3-msg 'workspace 2; layout tabbed; exec teams'

i3-msg 'workspace 2; layout tabbed; exec p3x-onenote'

i3-msg 'mode "default"'
