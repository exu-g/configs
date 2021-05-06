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
                echo "nyarch" > "$HOME/.seltheme"
                ;;
            2)
                echo "space-pink" > "$HOME/.seltheme"
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
git clone https://gitlab.com/RealStickman-arch/config.git &>/dev/null

# make sure to use master branch
cd config
git checkout master &>/dev/null
cd ..

# check if the install scripts are the same
# NOTE Arguments get passed automatically now
if ! cmp --silent "$HOME/scripts/arch-config.sh" "$HOME/config/scripts/arch-config.sh" ; then
    echo Removed old config file and launched new one.
    rm "$HOME/scripts/arch-config.sh" && cp "$HOME/config/scripts/arch-config.sh" "$HOME/scripts/" && bash ~/scripts/arch-config.sh "$@"
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
elif [[ "$#" -gt 1 ]]; then
    echo "Too many arguments"
    exit 1
fi

#delete previous backups
echo Removing old backup
if [[ -d ~/old_dat ]]; then
    rm -rf ~/old_dat
fi

# make new backup
echo Creating backup
mkdir -p ~/old_dat/.config || echo Directory already exists
mkdir -p ~/old_dat/.doom.d || echo Directory already exists
mkdir -p ~/old_dat/.easystroke || echo Directory already exists
mkdir -p ~/old_dat/.mozilla || echo Directory already exists
mkdir -p ~/old_dat/scripts || echo Directory already exists
mkdir -p ~/old_dat/.elvish || echo Directory already exists

# make subdirectories
mkdir -p ~/old_dat/.local/share || echo Directory already exists

##############################
# back stuff up
##############################
#config folders
if [[ -d ~/.config/MangoHud ]]; then
    rsync -ah ~/.config/MangoHud ~/old_dat/.config/ || echo Directory does not exist
fi
if [[ -d ~/.config/fish ]]; then
    rsync -ah ~/.config/fish ~/old_dat/.config/ || echo Directory does not exist
fi
if [[ -d ~/.config/gtk-3.0 ]]; then
    rsync -ah ~/.config/gtk-3.0 ~/old_dat/.config/ || echo Directory does not exist
fi
if [[ -d ~/.config/i3 ]]; then
    rsync -ah ~/.config/i3 ~/old_dat/.config/ || echo Directory does not exist
fi
if [[ -d ~/.config/neofetch ]]; then
    rsync -ah ~/.config/neofetch ~/old_dat/.config/ || echo Directory does not exist
fi
if [[ -d ~/.config/openbox ]]; then
    rsync -ah ~/.config/openbox ~/old_dat/.config/ || echo Directory does not exist
fi
if [[ -d ~/.config/polybar ]]; then
    rsync -ah ~/.config/polybar ~/old_dat/.config/ || echo Directory does not exist
fi
if [[ -d ~/.config/termite ]]; then
    rsync -ah ~/.config/termite ~/old_dat/.config/ || echo Directory does not exist
fi
if [[ -d ~/.config/variety ]]; then
    rsync -ah ~/.config/variety ~/old_dat/.config/ || echo Directory does not exist
fi

# doom.d folder
if [[ -d ~/.doom.d ]]; then
    rsync -ah ~/.doom.d ~/old_dat/ || echo Directory does not exist
fi

# easystroke
if [[ -d ~/.easystroke ]]; then
    rsync -ah ~/.easystroke ~/old_dat/ || echo Directory does not exist
fi

# elvish
if [[ -d ~/.elvish ]]; then
    rsync -ah ~/.elvish ~/old_dat/ || echo Directory does not exist
fi

# local folder
if [[ -d ~/.local/share/applications ]]; then
    rsync -ah ~/.local/share/applications/ ~/old_dat/.local/share/ || echo Directory does not exist
fi

# mozilla
if [[ -d ~/.mozilla ]]; then
    rsync -ah ~/.mozilla ~/old_dat/ || echo Directory does not exist
fi

# scripts
if [[ -d ~/scripts ]]; then
    rsync -ah ~/scripts ~/old_dat/ || echo Directory does not exist
fi

echo Made backups

# remove old templates
if [[ -d ~/.config/Vorlagen ]]; then
    rm -r ~/.config/Vorlagen
fi

#copy folders
cp -r ~/config/.config/ ~/
cp -r ~/config/.local/ ~/
#cp -r ~/config/Dokumente ~/
cp -r ~/config/.mozilla ~/
cp -r ~/config/.easystroke ~/
cp -r ~/config/.elvish ~/
cp -r ~/config/.doom.d ~/
echo Copied folders

#copy single files
cp -r ~/config/.bashrc ~/
cp -r ~/config/.face ~/
cp -r ~/config/.gtkrc-2.0 ~/
cp -r ~/config/.gitconfig ~/
#cp -r ~/config/.fehbg ~/
cp -r ~/config/.tmux.conf ~/
cp -r ~/config/.xinitrc ~/
echo Copied files

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

# remove old themes folder
rm -rf ./themes

# install theme selected in themes file
git clone https://gitlab.com/RealStickman-arch/themes.git &>/dev/null
seltheme="$(cat "$HOME/.seltheme")"
if [[ "$seltheme" == "nyarch" ]]; then
    #cp -r "./themes/nyarch/i3" "$HOME/.config/"
    cat "./themes/nyarch/i3/color" >> "$HOME/.config/i3/config"
    cp -r "./themes/nyarch/polybar" "$HOME/.config/"
    cp -r "./themes/nyarch/neofetch/lowpoly_flamegirl_blue.txt" "$HOME/.config/neofetch/lowpoly_flamegirl.txt"
    cp "./themes/.fehbg-nyarch" "$HOME/.fehbg"
    #sed -i 's/^NAME=".*"/NAME="Rawrch Linyux"/' /etc/os-release
elif [[ "$seltheme" == "space-pink" ]]; then
    #cp -r "./themes/space-pink/i3" "$HOME/.config/"
    cat "./themes/space-pink/i3/color" >> "$HOME/.config/i3/config"
    cp -r "./themes/space-pink/polybar" "$HOME/.config/"
    cp -r "./themes/space-pink/neofetch/lowpoly_flamegirl_orange.txt" "$HOME/.config/neofetch/lowpoly_flamegirl.txt"
    cp "./themes/.fehbg-space-pink" "$HOME/.fehbg"
fi
rm -rf ./themes

# make fehbg executable
chmod +x ~/.fehbg

# download cat as cat
echo "Installing bash cat"
git clone https://github.com/RealStickman/bash-cat-with-cat.git &>/dev/null
cp ./bash-cat-with-cat/cat.sh "$HOME/scripts/pieces/cat.sh"
rm -rf ./bash-cat-with-cat

#gimp plugins
#mkdir ~/.config/GIMP/ || echo Not creating directory
#mkdir ~/.config/GIMP/2.10/ || echo Not creating directory
mkdir -p ~/.config/GIMP/2.10/plug-ins/ || echo Not creating directory
rsync -ah ~/config/gimp-plugins/* ~/.config/GIMP/2.10/plug-ins/

# set systemd stuff for vmware (only if installed)
if [[ $(pacman -Q | grep vmware-workstation) ]]; then
    sudo systemctl enable --now vmware-networks-server.service
fi

# add group for corectrl
echo "Setting up group for corectrl"
sudo groupadd -f corectrl
sudo gpasswd -a "$USER" corectrl 1>/dev/null

# enable fstrim timer
sudo systemctl enable fstrim.timer

# enable btrfs maintenance timers
if [[ $(pacman -Q | grep btrfsmaintenance) ]]; then
    sudo systemctl restart btrfsmaintenance-refresh.service
    sudo systemctl enable btrfs-balance.timer
    sudo systemctl enable btrfs-scrub.timer
fi

#unzip gimp plugins
echo Unzipping gimp plugins
unzip -o ~/.config/GIMP/2.10/plug-ins/export_layers-3.3.1.zip -d ~/.config/GIMP/2.10/plug-ins/ > /dev/null
rm ~/.config/GIMP/2.10/plug-ins/export_layers-3.3.1.zip > /dev/null
echo Unzipped gimp plugins

# xfce settings
# disable screensaver & locker
/usr/bin/xfconf-query -c xfce4-session -n -t bool -p /startup/screensaver/enabled -s false

#make bash scripts executable
chmod +x -R ~/.config/polybar/
chmod +x -R ~/.config/i3/scripts
chmod +x -R ~/scripts

# make applications executable
chmod +x -R ~/.local/share/applications

# set settings for nemo
bash ~/config/scripts/nemo-config.sh

#remove downloaded folder
rm -rf ~/config

# reload applications
update-desktop-database ~/.local/share/applications/

#sync doom-emacs
~/.emacs.d/bin/doom sync

# reload systemd user scripts
systemctl --user daemon-reload

# reload .Xresources
if [[ -f "$HOME/.Xresources" ]]; then
    xrdb ~/.Xresources
fi

# execute feh
"$HOME/.fehbg"

# TODO make this only run if i3 is actually active
# if [[ "$(ps aux | grep "FIXME")" ]]; then ...
# ps aux | grep "\si3\s" breaks if i3 hasn't been restarted yet
# ps aux | grep "\si3" works for both, not certain if other stuff could be detected as well
# ps aux | grep "\si3\$" breaks if i3 has been restarted already in this session
if ps aux | grep -E "\si3(\s|$)" &>/dev/null; then
    i3-msg restart 1>/dev/null
fi

#output
echo -e "\033[38;2;20;200;20mFinished updating everything!\033[0m"
echo Launching new shell!

# remind user of cgroupsv2 if using podman
if [[ $(pacman -Q | grep podman) ]]; then
    echo -e "\033[38;2;200;20;20mRemember to set \"systemd.unified_cgroup_hierarchy=1\" in the kernel!!\033[0m"
fi

# reminder for enable additional gpu features for corectrl with amd gpus
if [[ $(pacman -Q | grep podman) ]]; then
    echo -e "\033[38;2;200;20;20mRemember to set \"amdgpu.ppfeaturemask=0xffffffff\" in the kernel!!\033[0m"
fi

# reload user default shell
exec "$(getent passwd $LOGNAME | cut -d: -f7)"

exit 0
