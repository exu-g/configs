#!/usr/bin/env sh

set -euo pipefail

# set GTK theme
gsettings set org.gnome.desktop.interface gtk-theme Sweet-Dark
# prefer dark variant
gsettings set org.gnome.desktop.interface color-scheme prefer-dark

# icon theme
gsettings set org.gnome.desktop.interface icon-theme Sweet-Rainbow

# Font
gsettings set org.gnome.desktop.interface font-name "Fira Sans 12"

# cursor theme
gsettings set org.gnome.desktop.interface cursor-theme "capitaine-cursors-light"
