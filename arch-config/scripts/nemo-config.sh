#!/usr/bin/env bash
set -euo pipefail

# set terminal emulator
gsettings set org.cinnamon.desktop.default-applications.terminal exec kitty

# list view
gsettings set org.nemo.preferences default-folder-viewer list-view

# show hidden files
gsettings set org.nemo.preferences show-hidden-files true

# show terminal button
gsettings set org.nemo.preferences show-open-in-terminal-toolbar true

# set zoom level for list view
gsettings set org.nemo.list-view default-zoom-level small

# TODO
gsettings set org.nemo.preferences show-edit-icon-toolbar false

# show sidebar
gsettings set org.nemo.window-state start-with-sidebar true

# enable "places" in sidebar
gsettings set org.nemo.window-state side-pane-view places

# enable open in terminal
gsettings set org.nemo.preferences.menu-config background-menu-open-in-terminal true

# disable favourites
gsettings set org.nemo.preferences.menu-config selection-menu-favorite false

# disable pin
gsettings set org.nemo.preferences.menu-config selection-menu-pin false

# enable changing keyboard shortcuts
gsettings set org.cinnamon.desktop.interface can-change-accels true
