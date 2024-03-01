#!/usr/bin/env sh

set -euo pipefail

# set GTK theme
gsettings set org.gnome.desktop.interface gtk-theme sweet
# prefer dark variant
gsettings set org.gnome.desktop.interface color-scheme prefer-dark

# icon theme
gsettings set org.gnome.desktop.interface icon-theme Sweet-Rainbow

# font config
gsettings set org.gnome.desktop.interface font-name "Fira Sans 12"
gsettings set org.gnome.desktop.interface font-hinting "slight"
gsettings set org.gnome.desktop.interface font-antialiasing "rgba"

# cursor theme
gsettings set org.gnome.desktop.interface cursor-theme "capitaine-cursors-light"
