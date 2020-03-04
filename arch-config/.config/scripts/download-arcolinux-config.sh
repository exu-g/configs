#!/bin/bash

#change to home (does not show in terminal)
cd $HOME

#remove old installs
rm -rf ~/arcolinux-config

#clone this repo
git clone https://gitlab.com/RealStickman/arcolinux-config.git &&

#copy stuff
cp -r ~/arcolinux-config/.config/ ~/ &&
cp ~/arcolinux-config/.bashrc ~/ &&
#copy commands
cp ~/arcolinux-config/Commands ~/Dokumente

#make bash scripts executable
chmod +x ~/.config/polybar/launch.sh
chmod +x ~/.config/scripts/startup.sh
chmod +x ~/.config/scripts/download-arcolinux-config.sh
chmod +x ~/.config/i3/scripts/i3exit.sh

#remove downloaded folder
rm -rf ~/arcolinux-config

#restart i3 in place
i3 restart

#output
echo Finished updating everything!
echo Launching new shell!

#new shell to reload .bashrc and fish config
exec bash