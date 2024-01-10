#!/usr/bin/env bash

set -euo pipefail

# function to select theme
function func_seltheme {
    cmd=(dialog --separate-output --checklist "Select theme (Only select one)" 22 76 16)
    options=(1 "Nyarch" off # any option can be set to default to "on"
        2 "Spaceengine Pink" off)
    choices=$("${cmd[@]}" "${options[@]}" 2>&1 >/dev/tty)
    clear
    for choice in $choices; do
        case $choice in
            1)
                echo "nyarch" >"$HOME/.seltheme"
                ;;
            2)
                echo "space-pink" >"$HOME/.seltheme"
                ;;
        esac
    done
}

# if no seltheme file exists, ask to select a theme
if [[ ! -f "$HOME/.seltheme" ]]; then
    func_seltheme
fi

####################
#### Arguments  ####
####################

copy_firefox=0

# handle arguments
if [[ "$#" -eq 1 ]]; then
    # -t/--theme to change theme
    if [[ "$1" == "-t" || "$1" == "--theme" ]]; then
        func_seltheme
    elif [[ "$1" == "-f" || "$1" == "--firefox" ]]; then
        copy_firefox=1
elif [[ "$#" -gt 1 ]]; then
    echo "Too many arguments"
    exit 1
fi

cat <<EOF
########################################
################ Backup ################
########################################
EOF

# Collect all PIDs of background processes that should be waited for
pids=""

####################
##### Cleaning #####
####################

#delete previous backups
echo Removing old backup
if [[ -d ~/old_dat ]]; then
    rm -rf ~/old_dat
fi

####################
##### Creating #####
####################

# make new backup
echo Creating backup
mkdir -p ~/old_dat/.config
mkdir -p ~/old_dat/.doom.d
mkdir -p ~/old_dat/.mozilla
mkdir -p ~/old_dat/scripts
mkdir -p ~/old_dat/.ssh

# make subdirectories
mkdir -p ~/old_dat/.local/share

#config folders
if [[ -d ~/.config/MangoHud ]]; then
    rsync -ah ~/.config/MangoHud ~/old_dat/.config/
fi
if [[ -d ~/.config/fish ]]; then
    rsync -ah ~/.config/fish ~/old_dat/.config/
fi
if [[ -d ~/.config/gtk-3.0 ]]; then
    rsync -ah ~/.config/gtk-3.0 ~/old_dat/.config/
fi
if [[ -d ~/.config/sway ]]; then
    rsync -ah ~/.config/sway ~/old_dat/.config/
fi
if [[ -d ~/.config/polybar ]]; then
    rsync -ah ~/.config/polybar ~/old_dat/.config/
fi

# doom.d folder
if [[ -d ~/.doom.d ]]; then
    rsync -ah ~/.doom.d ~/old_dat/
fi

# .ssh folder
if [[ -d ~/.ssh ]]; then
    rsync -ah ~/.ssh ~/old_dat/
fi

# local folder
if [[ -d ~/.local/share/applications ]]; then
    rsync -ah ~/.local/share/applications/ ~/old_dat/.local/share/
fi

# mozilla
if [[ -d ~/.mozilla ]]; then
    rsync -ah ~/.mozilla ~/old_dat/
fi

# scripts
if [[ -d ~/scripts ]]; then
    rsync -ah ~/scripts ~/old_dat/
fi

# remove old templates
if [[ -d ~/.config/Vorlagen ]]; then
    rm -r ~/.config/Vorlagen
fi

# remove old scripts in path
if [[ -d ~/scripts/in_path ]]; then
    rm -r ~/scripts/in_path
fi

# remove old script pieces
if [[ -d ~/scripts/pieces ]]; then
    rm -r ~/scripts/pieces
fi

# remove old polybar scripts
if [[ -d ~/scripts/polybar ]]; then
    rm -r ~/scripts/polybar
fi

# remove archived scripts
if [[ -d ~/scripts/archive ]]; then
    rm -r ~/scripts/archive
fi

cat <<EOF
########################################
########### Copy New Config  ###########
########################################
EOF

#copy folders
cp -r "$tempdir/arch-config/.config/" ~/
cp -r "$tempdir/arch-config/.local/" ~/
cp -r "$tempdir/arch-config/.ssh" ~/

# copy firefox only if "-f" or "--firefox" is given as argument
if [[ copy_firefox -eq 1 ]]; then
    if [[ -d ~/.mozilla/firefox ]]; then
        # NOTE check if firefox default-release directory exists. 1 is good, 0 is bad
        firefoxdir=$(find ~/.mozilla/firefox/ -name \*.default-release | wc -l)
        if [[ $firefoxdir -eq 1 ]]; then
            cp -r "$tempdir/arch-config/.mozilla/firefox/default-release/"* ~/.mozilla/firefox/*.default-release/
        else
            echo "Please launch firefox and then update the config again"
        fi
    else
        echo "Please launch firefox and then update the config again"
    fi
fi

#copy single files
cp -r "$tempdir/arch-config/.face" ~/
cp -r "$tempdir/arch-config/.gtkrc-2.0" ~/
cp -r "$tempdir/arch-config/.gitconfig" ~/
cp -r "$tempdir/arch-config/.xinitrc" ~/
cp -r "$tempdir/arch-config/.kopiaignore" ~/
echo Copied files

# make .xinitrc executable
chmod +x ~/.xinitrc

#copy scripts
cp -r "$tempdir/arch-config/scripts/" ~/

echo Copied folders

# copy xresources for sway
cp "$tempdir/arch-config/.Xdefaults" ~/

echo Copied single files

cat <<EOF
##############################
##### Per Device Settings ####
##############################
EOF

# lupusregina
# TODO analyse parts necessary for Wayland with Alita
if [ "$(hostname)" == "lupusregina" ]; then
    echo "Applying overrides for $(hostname)"
    # polybar dpi
    polybardpi="$(cat ~/configs/arch-config/per-device/lupusregina/polybar-dpi-override.ini)"
    awk -v polybardpi="$polybardpi" '/;per-device dpi insert/{print;print polybardpi;next}1' ~/.config/polybar/i3config.ini >/tmp/i3config.ini
    cp /tmp/i3config.ini ~/.config/polybar/i3config.ini
    # xresources dpi
    xftdpi="$(cat ~/configs/arch-config/per-device/lupusregina/xresources-dpi-override)"
    awk -v xftdpi="$xftdpi" '/!per-device dpi insert/{print;print xftdpi;next}1' ~/.Xdefaults >/tmp/.Xdefaults
    cp /tmp/.Xdefaults ~/.Xdefaults
fi

cat <<EOF
####################
###### Theme  ######
####################
EOF

# install theme selected in themes file
seltheme="$(cat "$HOME/.seltheme")"
if [[ "$seltheme" == "nyarch" ]]; then
    #cp -r "./themes/nyarch/i3" "$HOME/.config/"
    cp "$tempdir/arch-themes/nyarch/sway/color" "$HOME/.config/sway/config.d/"
    #cp -r "$HOME/configs/arch-themes/nyarch/polybar" "$HOME/.config/"
    #cp -r "./themes/nyarch/neofetch/lowpoly_flamegirl_blue.txt" "$HOME/.config/neofetch/lowpoly_flamegirl.txt"
    #cp "./themes/.fehbg-nyarch" "$HOME/.fehbg"
    #sed -i 's/^NAME=".*"/NAME="Rawrch Linyux"/' /etc/os-release
elif [[ "$seltheme" == "space-pink" ]]; then
    #cp -r "./themes/space-pink/i3" "$HOME/.config/"
    cp "$tempdir/arch-themes/space-pink/sway/color" "$HOME/.config/sway/config.d/"
    #cp -r "$HOME/configs/arch-themes/space-pink/polybar" "$HOME/.config/"
    #cp -r "./themes/space-pink/neofetch/lowpoly_flamegirl_orange.txt" "$HOME/.config/neofetch/lowpoly_flamegirl.txt"
    #cp "./themes/.fehbg-space-pink" "$HOME/.fehbg"
fi

# copy chosen image for lockscreen and desktop
backgroundimage="/home/exu/Bilder/Backgrounds/artstation/dk-lan/artstation_14224733_55806391_月半与鬼哭.jpg"

mkdir -p "$HOME/.cache/backgrounds"
cp "$backgroundimage" "$HOME/.cache/backgrounds/desktop"
cp "$backgroundimage" "$HOME/.cache/backgrounds/lockscreen"

chmod +x "$HOME/scripts/gsettings.sh"
bash "$HOME/scripts/gsettings.sh"
echo "Set theme using gsettings"

cat <<EOF
####################
##### Bash Cat #####
####################
EOF

# download cat as cat
echo "Installing bash cat"
mkdir "$tempdir/bash-cat-with-cat"
git clone https://github.com/RealStickman/bash-cat-with-cat.git "$tempdir/bash-cat-with-cat" &>/dev/null
cp "$tempdir/bash-cat-with-cat/cat.sh" "$HOME/scripts/pieces/cat.sh"

cat <<EOF
########################################
############### Autostart ##############
########################################
EOF

# create autostart directory
mkdir -p ~/.config/autostart/

# copy corectrl desktop file
if [[ $(pacman -Q | grep corectrl) ]]; then
    cp /usr/share/applications/org.corectrl.corectrl.desktop ~/.config/autostart/org.corectrl.corectrl.desktop
fi

cat <<EOF
########################################
############### Services ###############
########################################
EOF

# reload systemd user scripts
systemctl --user daemon-reload

# enable ssh-agent
systemctl --user enable --now ssh-agent

cat <<EOF
########################################
############# Misc Config  #############
########################################
EOF

#make bash scripts executable
chmod +x -R ~/.config/polybar/
chmod +x -R ~/.config/sway/scripts
chmod +x -R ~/scripts

# make applications executable
chmod +x -R ~/.local/share/applications

#remove downloaded folder
rm -rf ~/config

cat <<EOF
########################################
############## Reloading  ##############
########################################
EOF

# reload applications
update-desktop-database ~/.local/share/applications/

# sync doom-emacs only if it is installed
if [[ -f  ~/.config/emacs/bin/doom ]]; then
    ~/.config/emacs/bin/doom sync &
    pids="$pids $!"
fi

if [ $XDG_SESSION_DESKTOP == "sway" ]; then
    swaymsg reload
    echo "Reloaded sway"
fi

# wait for all background jobs to finish
wait $pids && echo "Finished background jobs"