#!/bin/bash

i3-msg 'mode "default"'

# workspace 1
i3-msg "workspace 1; append_layout ~/.config/i3/layouts/layout-default/workspace-1.json"

(kitty &)

# workspace 2
i3-msg "workspace 2; append_layout ~/.config/i3/layouts/layout-default/workspace-2.json"

(firefox &)
(thunderbird &)
(joplin-desktop &)
(discord &)

# workspace 3
i3-msg "workspace 3; append_layout ~/.config/i3/layouts/layout-default/workspace-3.json"

(emacs &)
