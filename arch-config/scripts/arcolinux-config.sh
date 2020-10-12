#!/bin/bash

set -euo pipefail

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
#config folders
rsync -ah --progress ~/.config/MangoHud ~/old_dat/.config/ &&
rsync -ah --progress ~/.config/autostart ~/old_dat/.config/ &&
rsync -ah --progress ~/.config/fish ~/old_dat/.config/ &&
rsync -ah --progress ~/.config/gtk-3.0 ~/old_dat/.config/ &&
rsync -ah --progress ~/.config/i3 ~/old_dat/.config/ &&
rsync -ah --progress ~/.config/neofetch ~/old_dat/.config/ &&
rsync -ah --progress ~/.config/openbox ~/old_dat/.config/ &&
rsync -ah --progress ~/.config/polybar ~/old_dat/.config/ &&
rsync -ah --progress ~/.config/termite ~/old_dat/.config/ &&
rsync -ah --progress ~/.config/variety ~/old_dat/.config/ &&

#other directories
rsync -ah --progress ~/scripts ~/old_dat/ &&
rsync -ah --progress ~/.mozilla ~/old_dat/ &&
rsync -ah --progress ~/.easystroke ~/old_dat/ &&
#rsync -ah --progress ~/.emacs.d ~/old_dat/ &&
rsync -ah --progress ~/.doom.d ~/old_dat/ &&
echo Made backups

#copy folders
cp -r ~/config/.config/ ~/ &&
cp -r ~/config/Dokumente ~/ &&
cp -r ~/config/.mozilla ~/ &&
cp -r ~/config/.easystroke ~/ &&
cp -r ~/config/.doom.d ~/ &&
echo Copied folders

#copy single files
cp -r ~/config/.bashrc ~/ &&
cp -r ~/config/.face ~/ &&
cp -r ~/config/.gtkrc-2.0 ~/ &&
cp -r ~/config/.gitconfig ~/ &&
echo Copied files

#copy scripts
cp -r ~/config/scripts/ ~/

#copy stuff to /etc
sudo cp -r ~/config/etc /

#copy old lightdm themes (and maybe other stuff, idk)
sudo cp -r ~/config/var /

#copy usr stuff
sudo cp -r ~/config/usr /

#gimp plugins
mkdir ~/.config/GIMP/
mkdir ~/.config/GIMP/2.10/
mkdir ~/.config/GIMP/2.10/plug-ins/
rsync -ah ~/config/gimp-plugins/* ~/.config/GIMP/2.10/plug-ins/

#unzip gimp plugins
echo Unzipping gimp plugins
unzip -o ~/.config/GIMP/2.10/plug-ins/export_layers-3.3.1.zip -d ~/.config/GIMP/2.10/plug-ins/
rm ~/.config/GIMP/2.10/plug-ins/export_layers-3.3.1.zip
echo Unzipped gimp plugins

#make bash scripts executable
chmod +x ~/.config/polybar/launch.sh
chmod +x ~/.config/i3/scripts/i3exit.sh
chmod +x ~/.config/i3/scripts/layout-default.sh
chmod +x ~/scripts/arcolinux-config.sh

#remove downloaded folder
rm -rf ~/config

#sync doom-emacs
~/.emacs.d/bin/doom sync

#restart i3 in place
i3 restart

#output
echo Finished updating everything!
echo Launching new shell!

#new shell to reload .bashrc and fish config
exec bash
