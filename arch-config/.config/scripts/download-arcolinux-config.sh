#!/bin/bash

rm -r -f ~/arcolinux-config

git clone https://gitlab.com/RealStickman/arcolinux-config.git &&

cp -r ~/arcolinux-config/.config/ ~/ &&
cp ~/arcolinux-config/.bashrc ~/ &&

chmod +x ~/.config/polybar/launch.sh
chmod +x ~/.config/scripts/startup.sh
chmod +x ~/.config/scripts/download-arcolinux-config.sh

rm -r -f ~/arcolinux-config

i3 restart