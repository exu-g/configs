#!/bin/bash

#ANY CHANGES TO THE INSTALLATION PROCEDURE SHOULD BE MADE HERE

#change to home (does not show in terminal)
cd $HOME

#remove old installs
rm -rf ~/config

#clone this repo
git clone https://gitlab.com/RealStickman-arcolinux/config.git &&

#copy stuff
cp -r ~/config/.config/ ~/ &&
cp ~/config/.bashrc ~/ &&
#copy commands
cp ~/config/Commands ~/Dokumente
cp ~/config/restic ~/Dokumente
#copy scripts
cp -r ~/config/scripts/ ~/
#copy stuff to /etc
sudo cp -r ~/config/etc /
#copy old lightdm themes (and maybe other stuff, idk)
sudo cp -r ~/config/var /

#gimp plugins
cp -r ~/config/gimp-plugins/* ~/.config/GIMP/2.10/plug-ins/ 
#unzip gimp plugins
echo Unzipping gimp plugins
unzip -o ~/.config/GIMP/2.10/plug-ins/export_layers-3.3.1.zip -d ~/.config/GIMP/2.10/plug-ins/
rm ~/.config/GIMP/2.10/plug-ins/export_layers-3.3.1.zip
echo Unzipped gimp plugins

#make bash scripts executable
chmod +x ~/.config/polybar/launch.sh
chmod +x ~/.config/scripts/startup.sh
chmod +x ~/.config/i3/scripts/i3exit.sh
chmod +x ~/scripts/arcolinux-config.sh

#remove downloaded folder
rm -rf ~/config

#restart i3 in place
i3 restart

#output
echo Finished updating everything!
echo Launching new shell!

#new shell to reload .bashrc and fish config
exec bash
