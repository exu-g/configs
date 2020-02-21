#!/bin/bash

git clone https://gitlab.com/RealStickman/arcolinux-config.git &&

cp -r /home/marc/arcolinux-config/.config/ /home/marc/.config/ &&
cp /home/marc/arcolinux-config/.bashrc /home/marc/

chmod +x /home/marc/.config/polybar/launch.sh
chmod +x /home/marc/.config/scripts/startup.sh
chmod +x /home/marc/.config/scripts/download-arcolinux-config.sh

rm -r -f /home/marc/arcolinux-config