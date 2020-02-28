#!/bin/bash

cd $HOME

rm -rf ~/arcolinux-config

git clone https://gitlab.com/RealStickman/arcolinux-config.git &&

cp -r ~/arcolinux-config/.config/ ~/ &&
cp ~/arcolinux-config/.bashrc ~/ &&

chmod +x ~/.config/polybar/launch.sh
chmod +x ~/.config/scripts/startup.sh
chmod +x ~/.config/scripts/download-arcolinux-config.sh

cp ~/arcolinux-config/Commands ~/Dokumente

rm -rf ~/arcolinux-config

i3 restart

echo Finished updating everything!
echo Launching new shell!

exec bash