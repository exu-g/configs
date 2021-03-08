#!/bin/bash

set -euo pipefail

#ANY CHANGES TO THE INSTALLATION PROCEDURE SHOULD BE MADE HERE

# function to select theme
function func_seltheme {
    cmd=(dialog --separate-output --checklist "Select theme (Only select one)" 22 76 16)
    options=(1 "Nyarch" off    # any option can be set to default to "on"
             2 "Spaceengine Pink" off)
    choices=$("${cmd[@]}" "${options[@]}" 2>&1 >/dev/tty)
    clear
    for choice in $choices
    do
        case $choice in
            1)
                echo "nyarch" >> "$HOME/.seltheme"
                ;;
            2)
                echo "space-pink" >> "$HOME/.seltheme"
                ;;
        esac
    done
}

# check if user is root
if [ "$EUID" -ne 0 ]; then
    sudo -l > /dev/null
fi

#change to home (does not show in terminal)
cd "$HOME"

#remove old installs
rm -rf ~/config

#clone this repo
git clone https://gitlab.com/RealStickman-arch/config.git &&

# check if the install scripts are the same
if ! cmp --silent "$HOME/scripts/arch-config.sh" "$HOME/config/scripts/arch-config.sh" ; then
    echo Removed old config file and launched new one.
    rm "$HOME/scripts/arch-config.sh" && cp "$HOME/config/scripts/arch-config.sh" "$HOME/scripts/" && bash ~/scripts/arch-config.sh
fi

# if no seltheme file exists, ask to select a theme
if [[ ! -f "$HOME/.seltheme" ]]; then
    func_seltheme
fi

##############################
#####     arguments      #####
##############################
# handle arguments
if [[ "$#" -eq 1 ]]; then
    # -t/--theme to change theme
    if [[ "$1" == "-t" || "$1" == "--theme" ]]; then
        func_seltheme
    elif [[ "$1" == "-h" || "$1" == "--help" ]]; then
        echo "-h, --help   Show help menu"
        echo "-t, --theme  Show theme selection screen"
    fi
fi

#delete previous backups
echo Removing old backup
rm -rf ~/old_dat

# make new backup
echo Creating backup
mkdir -p ~/old_dat/.config || echo Directory already exists
mkdir -p ~/old_dat/.doom.d || echo Directory already exists
mkdir -p ~/old_dat/.easystroke || echo Directory already exists
mkdir -p ~/old_dat/.mozilla || echo Directory already exists
mkdir -p ~/old_dat/scripts || echo Directory already exists

# make subdirectories
mkdir -p ~/old_dat/.local/share || echo Directory already exists

##############################
# back stuff up
##############################
#config folders
rsync -ah ~/.config/MangoHud ~/old_dat/.config/ || echo Directory does not exist
rsync -ah ~/.config/fish ~/old_dat/.config/ || echo Directory does not exist
rsync -ah ~/.config/gtk-3.0 ~/old_dat/.config/ || echo Directory does not exist
rsync -ah ~/.config/i3 ~/old_dat/.config/ || echo Directory does not exist
rsync -ah ~/.config/neofetch ~/old_dat/.config/ || echo Directory does not exist
rsync -ah ~/.config/openbox ~/old_dat/.config/ || echo Directory does not exist
rsync -ah ~/.config/polybar ~/old_dat/.config/ || echo Directory does not exist
rsync -ah ~/.config/termite ~/old_dat/.config/ || echo Directory does not exist
rsync -ah ~/.config/variety ~/old_dat/.config/ || echo Directory does not exist

# doom.d folder
rsync -ah ~/.doom.d ~/old_dat/ || echo Directory does not exist

# easystroke
rsync -ah ~/.easystroke ~/old_dat/ || echo Directory does not exist

# local folder
rsync -ah ~/.local/share/applications/ ~/old_dat/.local/share/ || echo Directory does not exist

# mozilla
rsync -ah ~/.mozilla ~/old_dat/ || echo Directory does not exist

# scripts
rsync -ah ~/scripts ~/old_dat/ || echo Directory does not exist
echo Made backups

# remove old templates
rm -r ~/.config/Vorlagen

#copy folders
cp -r ~/config/.config/ ~/ &&
cp -r ~/config/.local/ ~/ &&
#cp -r ~/config/Dokumente ~/ &&
cp -r ~/config/.mozilla ~/ &&
cp -r ~/config/.easystroke ~/ &&
cp -r ~/config/.doom.d ~/ &&
echo Copied folders

#copy single files
cp -r ~/config/.bashrc ~/ &&
cp -r ~/config/.face ~/ &&
cp -r ~/config/.gtkrc-2.0 ~/ &&
cp -r ~/config/.gitconfig ~/ &&
cp -r ~/config/.fehbg ~/ &&
cp -r ~/config/.tmux.conf ~/ &&
cp -r ~/config/.xinitrc ~/ &&
echo Copied files

# make fehbg executable
chmod +x ~/.fehbg

# make .xinitrc executable
chmod +x ~/.xinitrc

#copy scripts
cp -r ~/config/scripts/ ~/

# copy cache
cp -r ~/config/.cache ~/

#copy stuff to /etc
sudo cp -r ~/config/etc /
#sudo rsync --exclude=default/grub ~/config/etc /etc/

#read -r -p "Do you want to overwrite the grub config? [y/N] " response
#if [[ "$response" =~ ^([yY][eE][sS][jJ]|[yY])$ ]]
#then
    # copy config
#    sudo cp ~/config/etc/default/grub /etc/default/
    # update grub
#    sudo grub-mkconfig -o /boot/grub/grub.cfg
#fi

# NOTE Distro specific stuff
distro=$(cat /etc/*-release | grep "^ID=")
if [ "$distro" == "ID=arcolinux" ]; then
    sudo mv /etc/arco-pacman.conf /etc/pacman.conf
fi
if [ "$distro" == "ID=arch" ]; then
    sudo mv /etc/arch-pacman.conf /etc/pacman.conf
fi

#copy old lightdm themes (and maybe other stuff, idk)
sudo cp -r ~/config/var /

#copy usr stuff
sudo cp -r ~/config/usr /

# copy xresources
cp ~/config/.Xresources ~/

# TODO
# copy theme select file
#cp ~/config/.seltheme ~/

# install theme selected in themes file
git clone https://gitlab.com/RealStickman-arch/themes.git
seltheme="$(cat "$HOME/.seltheme")"
if [[ "$seltheme" == "nyarch" ]]; then
    cp -r "./themes/nyarch/i3" "$HOME/.config/"
    cp -r "./themes/nyarch/polybar" "$HOME/.config/"
elif [[ "$seltheme" == "space-pink" ]]; then
    cp -r "./themes/space-pink/i3" "$HOME/.config/"
    cp -r "./themes/space-pink/polybar" "$HOME/.config/"
fi
rm -rf ./themes

# download cat as cat
git clone https://github.com/RealStickman/bash-cat-with-cat.git
cp ./bash-cat-with-cat/cat.sh "$HOME/scripts/pieces/cat.sh"
rm -rf ./bash-cat-with-cat

#gimp plugins
#mkdir ~/.config/GIMP/ || echo Not creating directory
#mkdir ~/.config/GIMP/2.10/ || echo Not creating directory
mkdir -p ~/.config/GIMP/2.10/plug-ins/ || echo Not creating directory
rsync -ah ~/config/gimp-plugins/* ~/.config/GIMP/2.10/plug-ins/

#unzip gimp plugins
echo Unzipping gimp plugins
unzip -o ~/.config/GIMP/2.10/plug-ins/export_layers-3.3.1.zip -d ~/.config/GIMP/2.10/plug-ins/ > /dev/null
rm ~/.config/GIMP/2.10/plug-ins/export_layers-3.3.1.zip > /dev/null
echo Unzipped gimp plugins

#make bash scripts executable
chmod +x -R ~/.config/polybar/
chmod +x -R ~/.config/i3/scripts
chmod +x -R ~/scripts

# make applications executable
chmod +x -R ~/.local/share/applications

#remove downloaded folder
rm -rf ~/config

# reload applications
update-desktop-database ~/.local/share/applications/

#sync doom-emacs
~/.emacs.d/bin/doom sync

# reload .Xresources
if [[ -f "$HOME/.Xresources" ]]; then
    xrdb ~/.Xresources
fi

# execute feh
"$HOME/.fehbg"

#restart i3 in place
i3 restart

#output
echo Finished updating everything!
echo Launching new shell!

# reload fish
exec fish

exit 0
