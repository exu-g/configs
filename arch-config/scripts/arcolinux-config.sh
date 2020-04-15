#!/bin/bash

#ANY CHANGES TO THE INSTALLATION PROCEDURE SHOULD BE MADE HERE

#change to home (does not show in terminal)
cd $HOME

#remove old installs
rm -rf ~/arcolinux-config

#clone this repo
git clone https://gitlab.com/RealStickman-arcolinux/arcolinux-config.git &&

#copy stuff
cp -r ~/arcolinux-config/.config/ ~/ &&
cp ~/arcolinux-config/.bashrc ~/ &&
#copy commands
cp ~/arcolinux-config/Commands ~/Dokumente
#copy scripts
cp -r ~/arcolinux-config/scripts/ ~/
#copy stuff to /etc
sudo cp -r ~/arcolinux-config/etc /

#gimp plugins
cp -r ~/arcolinux-config/gimp-plugins ~/.config/GIMP/2.10/plug-ins/
unzip export_layers-3.3.1.zip
#rm export_layers-3.3.1.zip

#make bash scripts executable
chmod +x ~/.config/polybar/launch.sh
chmod +x ~/.config/scripts/startup.sh
chmod +x ~/.config/i3/scripts/i3exit.sh
chmod +x ~/scripts/arcolinux-config.sh

#remove downloaded folder
rm -rf ~/arcolinux-config

#restart i3 in place
i3 restart

#output
echo Finished updating everything!
echo Launching new shell!

#new shell to reload .bashrc and fish config
exec bash
