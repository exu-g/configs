#!/usr/bin/env python3
import subprocess
import os
import uuid
import glob
import shutil
import filecmp
import importlib.util
import sys


def select_theme():
    """
    Function to select a different theme
    """
    pass


def install_theme():
    """
    Install most up to date version of the theme
    """
    """
# remove old themes folder
rm -rf ./themes

# install theme selected in themes file
git clone https://gitlab.com/RealStickman-arch/themes.git &>/dev/null
seltheme="$(cat "$HOME/.seltheme")"
if [[ "$seltheme" == "nyarch" ]]; then
    #cp -r "./themes/nyarch/i3" "$HOME/.config/"
    cat "./themes/nyarch/i3/color" >>"$HOME/.config/i3/config"
    cp -r "./themes/nyarch/polybar" "$HOME/.config/"
    cp -r "./themes/nyarch/neofetch/lowpoly_flamegirl_blue.txt" "$HOME/.config/neofetch/lowpoly_flamegirl.txt"
    #cp "./themes/.fehbg-nyarch" "$HOME/.fehbg"
    #sed -i 's/^NAME=".*"/NAME="Rawrch Linyux"/' /etc/os-release
elif [[ "$seltheme" == "space-pink" ]]; then
    #cp -r "./themes/space-pink/i3" "$HOME/.config/"
    cat "./themes/space-pink/i3/color" >>"$HOME/.config/i3/config"
    cp -r "./themes/space-pink/polybar" "$HOME/.config/"
    cp -r "./themes/space-pink/neofetch/lowpoly_flamegirl_orange.txt" "$HOME/.config/neofetch/lowpoly_flamegirl.txt"
    #cp "./themes/.fehbg-space-pink" "$HOME/.fehbg"
fi
rm -rf ./themes

# make fehbg executable
chmod +x ~/.fehbg
    """
    pass


def install_bash_cat():
    """
    Install a cute cat
    """
    """
# download cat as cat
echo "Installing bash cat"
git clone https://github.com/RealStickman/bash-cat-with-cat.git &>/dev/null
cp ./bash-cat-with-cat/cat.sh "$HOME/scripts/pieces/cat.sh"
rm -rf ./bash-cat-with-cat
    """
    pass


def install_psipcalc():
    """
    A PowerShell ip calculator
    """
    """
# download ip-calculator with powershell
echo "Installing powershell ip calculator"
git clone https://github.com/RealStickman/PSipcalc &>/dev/null
cp ./PSipcalc/PSipcalc.ps1 "$HOME/scripts/in_path/sc-psipcalc"
rm -rf ./PSipcalc
    """
    pass


def update_firefox():
    """
    Function to also update firefox config
    """
    pass


def autostart():
    """
    Programs with autostart functionality
    """
    """
# copy corectrl desktop file
if [[ $(pacman -Q | grep corectrl) ]]; then
    cp /usr/share/applications/org.corectrl.corectrl.desktop ~/.config/autostart/org.corectrl.corectrl.desktop
fi
    """
    pass


def services():
    """
    Enable and start systemd services
    """
    """
# set systemd services for vmware (only if installed)
if [[ $(pacman -Q | grep vmware-workstation) ]]; then
    sudo systemctl enable --now vmware-networks.service || echo "Service failed, continuing"
    sudo systemctl enable --now vmware-usbarbitrator.service || echo "Service failed, continuing"
fi

# NOTE temporary
# remove old vmware services
if [ -f "/etc/systemd/system/vmware.service" ]; then
    sudo rm "/etc/systemd/system/vmware.service"
fi
if [ -f "/etc/systemd/system/vmware-networks-server.service" ]; then
    sudo rm "/etc/systemd/system/vmware-networks-server.service"
fi
if [ -f "/etc/systemd/system/vmware-usbarbitrator.service" ]; then
    sudo rm "/etc/systemd/system/vmware-usbarbitrator.service"
fi

# enable fstrim timer
sudo systemctl enable fstrim.timer

# enable btrfs maintenance timers
if [[ $(pacman -Q | grep btrfsmaintenance) ]]; then
    sudo systemctl restart btrfsmaintenance-refresh.service
    sudo systemctl enable btrfs-balance.timer
    sudo systemctl enable btrfs-scrub.timer
fi

# enable systemd-timesyncd (ntp service)
sudo timedatectl set-ntp true

# enable ssh-agent
systemctl --user enable --now ssh-agent
    """
    pass


def groupmanagement():
    """
    Manage user groups
    """
    """
# set systemd and group for vmware (only if installed)
if [[ $(pacman -Q | grep vmware-workstation) ]]; then
    echo "Setting up group for vmware"
    sudo groupadd -f vmware
    sudo gpasswd -a "$USER" vmware 1>/dev/null
    sudo chgrp vmware /dev/vmnet*
    sudo chmod g+rw /dev/vmnet*
fi

# set group for libvirt
if [[ $(pacman -Q | grep libvirt) ]]; then
    echo "Setting group for libvirt"
    sudo gpasswd -a "$USER" libvirt 1>/dev/null
fi

# set group for wireshark (only if installed)
if [[ $(pacman -Q | grep wireshark-qt) ]]; then
    echo "Setting up group for wireshark"
    sudo groupadd -f wireshark
    sudo gpasswd -a "$USER" wireshark 1>/dev/null
fi

# add group for corectrl
if [[ $(pacman -Q | grep corectrl) ]]; then
    echo "Setting up group for corectrl"
    sudo groupadd -f corectrl
    sudo gpasswd -a "$USER" corectrl 1>/dev/null
fi

# group for controlling backlight
echo "Setting group for backlight"
sudo groupadd -f video
sudo gpasswd -a "$USER" video 1>/dev/null

# group for monitoring wireguard
echo "Setting group for wireguard"
sudo groupadd -f wireguard
sudo gpasswd -a "$USER" wireguard 1>/dev/null
    """
    pass


def miscellaneous():
    """
    Miscellaneous config items
    """
    """
# automatically add ssh keys to agent
#if ! grep -q "AddKeysToAgent yes" "$HOME/.ssh/config"; then
#    echo 'AddKeysToAgent yes' | cat - "$HOME/.ssh/config" > temp && mv temp "$HOME/.ssh/config"
#fi

# set permissions for sudoers.d to root only
sudo chown root:root -R /etc/sudoers.d/
sudo chmod 600 -R /etc/sudoers.d/

# unzip gimp plugins
echo Unzipping gimp plugins
unzip -o ~/.config/GIMP/2.10/plug-ins/export_layers-3.3.1.zip -d ~/.config/GIMP/2.10/plug-ins/ >/dev/null
rm ~/.config/GIMP/2.10/plug-ins/export_layers-3.3.1.zip >/dev/null

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
    """
    pass


def create_backup():
    """
    Create a backup of old config files
    """
    """
# make new backup
echo Creating backup
mkdir -p ~/old_dat/.config
mkdir -p ~/old_dat/.doom.d
mkdir -p ~/old_dat/.easystroke
mkdir -p ~/old_dat/.mozilla
mkdir -p ~/old_dat/scripts
mkdir -p ~/old_dat/.elvish
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
if [[ -d ~/.config/i3 ]]; then
    rsync -ah ~/.config/i3 ~/old_dat/.config/
fi
if [[ -d ~/.config/neofetch ]]; then
    rsync -ah ~/.config/neofetch ~/old_dat/.config/
fi
if [[ -d ~/.config/openbox ]]; then
    rsync -ah ~/.config/openbox ~/old_dat/.config/
fi
if [[ -d ~/.config/polybar ]]; then
    rsync -ah ~/.config/polybar ~/old_dat/.config/
fi
if [[ -d ~/.config/termite ]]; then
    rsync -ah ~/.config/termite ~/old_dat/.config/
fi
if [[ -d ~/.config/variety ]]; then
    rsync -ah ~/.config/variety ~/old_dat/.config/
fi

# doom.d folder
if [[ -d ~/.doom.d ]]; then
    rsync -ah ~/.doom.d ~/old_dat/
fi

# .ssh folder
if [[ -d ~/.ssh ]]; then
    rsync -ah ~/.ssh ~/old_dat/
fi

# easystroke
if [[ -d ~/.easystroke ]]; then
    rsync -ah ~/.easystroke ~/old_dat/
fi

# elvish
if [[ -d ~/.elvish ]]; then
    rsync -ah ~/.elvish ~/old_dat/
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
    """
    pass


def new_config():
    """
    Copy files for new config
    """
    """
#copy folders
cp -r ~/config/.config/ ~/
cp -r ~/config/.local/ ~/
#cp -r ~/config/Dokumente ~/
cp -r ~/config/.mozilla/firefox/default-release/* ~/.mozilla/firefox/*.default-release/
cp -r ~/config/.easystroke ~/
cp -r ~/config/.elvish ~/
cp -r ~/config/.doom.d ~/
cp -r ~/config/.ssh ~/
echo Copied folders

#copy single files
cp -r ~/config/.bashrc ~/
cp -r ~/config/.face ~/
cp -r ~/config/.gtkrc-2.0 ~/
cp -r ~/config/.gitconfig ~/
cp -r ~/config/.tmux.conf ~/
cp -r ~/config/.xinitrc ~/
cp -r ~/config/.kopiaignore ~/
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

# NOTE only for webkit2gtk version of lightdm
#copy old lightdm themes (and maybe other stuff, idk)
#sudo cp -r ~/config/var /

#copy usr stuff
sudo cp -r ~/config/usr /

# copy xresources
cp ~/config/.Xresources ~/
    """
    pass


def reloading():
    """
    Reload changes into the running system
    """
    """
# reload applications
update-desktop-database ~/.local/share/applications/

#sync doom-emacs
~/.emacs.d/bin/doom sync

# disable freedesktop notification daemon
if [[ -f "/usr/share/dbus-1/services/org.freedesktop.Notifications.service" ]]; then
    sudo mv /usr/share/dbus-1/services/org.freedesktop.Notifications.service /usr/share/dbus-1/services/org.freedesktop.Notifications.service.disabled
fi

# dunst
pkill dunst && nohup dunst &

# reload systemd user scripts
systemctl --user daemon-reload

# reload .Xresources
if [[ -f "$HOME/.Xresources" ]]; then
    xrdb ~/.Xresources
fi

# execute feh
"$HOME/.fehbg"

# NOTE working now
# if [[ "$(ps aux | grep "FIXME")" ]]; then ...
# ps aux | grep "\si3\s" breaks if i3 hasn't been restarted yet
# ps aux | grep "\si3" works for both, not certain if other stuff could be detected as well
# ps aux | grep "\si3\$" breaks if i3 has been restarted already in this session
if ps aux | grep -E "\si3(\s|$)" &>/dev/null; then
    i3-msg restart 1>/dev/null
fi
    """
    pass


def final_output():
    """
    Some last words
    """
    """
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
    """
    pass


def main():
    # TODO
    if not os.path.isfile(os.path.join(home, ".seltheme")):
        select_theme()

    # TODO remove previous backup
    # ~/old_dat

    # TODO create new backup
    create_backup()

    # TODO copy new config files
    new_config()

    # TODO install theme
    install_theme()

    # TODO install bash cat
    install_bash_cat()

    # TODO install psipcalc
    install_psipcalc()

    # TODO autostart programs
    autostart()

    # TODO systemd services
    services()

    # TODO user groups and permissions
    groupmanagement()

    # TODO miscellaneous items
    miscellaneous()

    # TODO reloading changes
    reloading()

    # TODO final outputs
    final_output()


# Set home path
home = os.path.expanduser("~")

# Check root or run as sudo
if os.getuid() != 0:
    subprocess.run("sudo -v", shell=True, check=True)

if __name__ == "__main__":
    # TODO arguments
    # -t: select theme
    # -f: update firefox config
    # -h: help

    # change to home directory
    os.chdir(home)

    # slightly random uuid for our config location
    configdir = "config-" + str(uuid.uuid1())

    # TODO remove old "config-" folder(s)
    # https://stackoverflow.com/a/70860760

    # clone git repo
    subprocess.run(
        "git clone https://gitlab.com/RealStickman-arch/config.git {configdir}".format(
            configdir=configdir
        ),
        shell=True,
        check=True,
    )

    os.chdir(configdir)
    subprocess.run(
        "git checkout master",
        shell=True,
        check=True,
        stderr=subprocess.STDOUT,
        stdout=subprocess.DEVNULL,
    )
    os.chdir(home)

    # check if downloaded script is different
    if not filecmp.cmp(
        os.path.join(home, "scripts/arch-config.py"),
        os.path.join(configdir, "scripts/arch-config.py"),
    ):
        print("Found newer config file")
        # import newer script version
        spec = importlib.util.spec_from_file_location(
            "config",
            os.path.join(configdir, "scripts/arch-config.py"),
        )
        config = importlib.util.module_from_spec(spec)
        sys.modules["config"] = config
        spec.loader.exec_module(config)
        # call new main function
        config.main()
    else:
        print("Config is up to date")
        # call main function
        main()
