#!/bin/bash

#ANY CHANGES TO THE INSTALLATION PROCEDURE SHOULD BE MADE HERE

#change to home (does not show in terminal)
cd $HOME

#remove old installs
rm -rf ~/config

#clone this repo
git clone https://gitlab.com/RealStickman-arcolinux/config.git &&

#delete previous backups
rm -rf ~/old_dat
#make new directory
mkdir ~/old_dat
#back stuff up
cp -r ~/.config ~/old_dat/.config &&
cp -r ~/Dokumente ~/old_dat/Dokumente &&
cp -r ~/scripts ~/old_dat/scripts &&
cp -r ~/.mozilla ~/old_dat/.mozilla &&
echo Made backups

#copy folders
cp -r ~/config/.config/ ~/ &&
cp -r ~/config/Dokumente ~/ &&
cp -r ~/config/.mozilla ~/ &&
echo Copied folders
#copy single files
cp ~/config/.bashrc ~/ &&
cp ~/config/.face ~/ &&
cp ~/config/.gtkrc-2.0 ~/ &&
echo Copied files
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
