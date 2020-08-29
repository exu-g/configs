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
rsync -ah --progress ~/.config ~/old_dat/.config &&
rsync -ah --progress ~/Dokumente ~/old_dat/Dokumente &&
rsync -ah --progress ~/scripts ~/old_dat/scripts &&
rsync -ah --progress ~/.mozilla ~/old_dat/.mozilla &&
rsync -ah --progress ~/.easystroke ~/old_dat/.easystroke &&

#cp -r ~/.config ~/old_dat/.config &&
#cp -r ~/Dokumente ~/old_dat/Dokumente &&
#cp -r ~/scripts ~/old_dat/scripts &&
#cp -r ~/.mozilla ~/old_dat/.mozilla &&
#cp -r ~/.easystroke ~/old_dat/.easystroke &&
echo Made backups

#copy folders
#rsync -ah --progress ~/config/.config/ ~/ &&
#rsync -ah --progress ~/config/Dokumente ~/ &&
#rsync -ah --progress ~/config/.mozilla ~/ &&
#rsync -ah --progress ~/config/.easystroke ~/ &&

cp -r ~/config/.config/ ~/ &&
cp -r ~/config/Dokumente ~/ &&
cp -r ~/config/.mozilla ~/ &&
mkdir ~/.easystroke
cp -r ~/config/.easystroke ~/ &&
echo Copied folders
#copy single files
#rsync -ah --progress ~/config/.bashrc ~/ &&
#rsync -ah --progress ~/config/.face ~/ &&
#rsync -ah --progress ~/config/.gtkrc-2.0 ~/ &&

cp -r ~/config/.bashrc ~/ &&
cp -r ~/config/.face ~/ &&
cp -r ~/config/.gtkrc-2.0 ~/ &&
cp -r ~/config/.gitconfig ~/ &&
echo Copied files
#copy scripts
#rsync -ah --progress ~/config/scripts/ ~/

cp -r ~/config/scripts/ ~/
#copy stuff to /etc
sudo cp -r ~/config/etc /
#copy old lightdm themes (and maybe other stuff, idk)
sudo cp -r ~/config/var /

#gimp plugins
mkdir ~/.config/GIMP/
mkdir ~/.config/GIMP/2.10/
mkdir ~/.config/GIMP/2.10/plug-ins/
#rsync -ah --progress ~/config/gimp-plugins/* ~/.config/GIMP/2.10/plug-ins/ 

rsync -ah ~/config/gimp-plugins/* ~/.config/GIMP/2.10/plug-ins/ 
#unzip gimp plugins
echo Unzipping gimp plugins
#unzip -o ~/.config/GIMP/2.10/plug-ins/export_layers-3.3.1.zip -d ~/.config/GIMP/2.10/plug-ins/
rm ~/.config/GIMP/2.10/plug-ins/export_layers-3.3.1.zip
echo Unzipped gimp plugins

#make bash scripts executable
chmod +x ~/.config/polybar/launch.sh
chmod +x ~/.config/i3/scripts/i3exit.sh
chmod +x ~/.config/i3/scripts/layout-default.sh
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
