#!/bin/bash

#change to home (does not show in terminal)
cd $HOME

sudo pacman -Sy

read -p "Remove Programs? [y|n]";
    if [ $REPLY == "y" ]; then
        echo Uninstalling unused packages
        sudo pacman -Rns evolution catfish geany vim keepass gnome-boxes sublime-text-dev atom adwaita-icon-theme arcolinux-i3wm-git arcolinux-tweak-tool-git arcolinux-welcome-app-git clonezilla evolution-data-server numix-circle-arc-icons-git numix-circle-icon-theme-git numix-gtk-theme-git numix-icon-theme-git oh-my-zsh-git pamac-aur qbittorrent vivaldi vlc code baka-mplayer tmux
        echo Uninstalled unused packages
    else
        echo "Didn't uninstall any packages"
    fi

#update stuff
echo Skipping updating packages
echo Updating packages
yay -Syyu
echo Updated packages

cmd=(dialog --separate-output --checklist "Select Desktop environment/Window manager:" 22 76 16)
options=(1 "[DE] xfce4" off    # any option can be set to default to "on"
         2 "[WM] i3-gaps" off)
choices=$("${cmd[@]}" "${options[@]}" 2>&1 >/dev/tty)
clear
for choice in $choices
do
    case $choice in
        1)
            sudo pacman -S --needed xfce4
            ;;
        2)
            sudo pacman -S --needed i3-gaps
            ;;
    esac
done

cmd=(dialog --separate-output --checklist "Select browsers:" 22 76 16)
options=(1 "Firefox" on    # any option can be set to default to "on"
         2 "Ungoogled-Chromium" off
         3 "Palemoon" off
         4 "Basilisk" off
         5 "Netsurf" off
         6 "Icecat" off
         7 "Torbrowser" on)
choices=$("${cmd[@]}" "${options[@]}" 2>&1 >/dev/tty)
clear
for choice in $choices
do
    case $choice in
        1)
            sudo pacman -S --needed qemu firefox
            echo Installed Firefox
            ;;
        2)
            sudo pacman -S --needed ungoogled-chromium
            echo Installed Ungoogled-Chromium
            ;;
        3)
            sudo pacman -S --needed palemoon
            echo Installed Palemoon
            ;;
        4)
            sudo pacman -S --needed basilisk
            echo Installed Basilisk
            ;;
        5)
            sudo pacman -S --needed netsurf
            echo Installed Netsurf
            ;;
        6)
            sudo yay -S --needed icecat-bin
            echo Installed Icecat
            ;;
        7)
            sudo pacman -S --needed torbrowser-launcher
            echo Installed Torbrowser
            ;;
    esac
done

cmd=(dialog --separate-output --checklist "Select other programs:" 22 76 16)
options=(1 "VirtManager" off    # any option can be set to default to "on"
         2 "Steam" off
         3 "Lutris" off
         4 "Blender" off
         5 "Krita" off
         6 "Youtube-dl" off
         7 "Discord" on
         8 "Handbrake" off
         9 "Gimp" off
         10 "Audacity" off
         11 "MangoHud" off
         12 "Easystroke" on
         13 "Liferea" off
         14 "Mirage (Matrix Client)" on
         15 "Bettergram (Telegram Client)" on
         16 "Pycharm")
choices=$("${cmd[@]}" "${options[@]}" 2>&1 >/dev/tty)
clear
for choice in $choices
do
    case $choice in
        1)
            sudo pacman -S --needed qemu virt-manager
            echo Installed VirtManager
            ;;
        2)
            sudo pacman -S --needed steam steam-native-runtime
            echo Installed Steam
            ;;
        3)
            sudo pacman -S --needed lutris
            echo Installed Lutris
            ;;
        4)
            sudo pacman -S --needed blender
            echo Installed Blender
            ;;
        5)
            sudo pacman -S --needed krita
            echo Installed Krita
            ;;
        6)
            sudo pacman -S --needed youtube-dl
            echo Installed Youtube-dl
            ;;
        7)
            sudo pacman -S --needed discord
            echo Installed Discord
            ;;
        8)
            sudo pacman -S --needed handbrake
            echo Installed Handbrake
            ;;
        9)
            sudo pacman -S --needed gimp
            echo Installed Gimp
            ;;
        10)
            sudo pacman -S --needed audacity
            echo Installed Audacity
            ;;
        11)
            git clone --recurse-submodules https://github.com/flightlessmango/MangoHud.git
            ./MangoHud/build.sh install
            echo Installed MangoHud
            ;;
        12)
            sudo yay -S --needed easystroke
            echo Installed Easystroke
            ;;
        13)
            sudo yay -S --needed liferea
            echo Installed Liferea
            ;;
        14)
            sudo yay -S --needed matrix-mirage
            echo Installed Mirage
            ;;
        15)
            sudo yay -S --needed bettergram
            echo Installed Bettergram
            ;;
        16)
            sudo pacman -S --needed pycharm-community-edition
            echo Installed Pycharm
            ;;
    esac
done

cmd=(dialog --separate-output --checklist "Report installed packages?" 22 76 16)
options=(1 "pkgstats" off)
choices=$("${cmd[@]}" "${options[@]}" 2>&1 >/dev/tty)
clear
for choice in $choices
do
    case $choice in
        1)
            sudo pacman -S --needed pkgstats
            ;;
    esac
done

echo Installing default pacman programs
sudo pacman -S --needed arandr libreoffice-fresh-de termite neofetch wget picom stress obs-studio  python-pip hunspell hunspell-de hyphen hyphen-de fish psensor transmission-qt smartmontools thunderbird ffmpeg jre-openjdk thunar gtk-engine-murrine iperf3 celluloid nload languagetool dmenu
echo Installed official programs

#AUR
echo Installing default AUR programs
yay -S --needed ttf-ms-fonts ttf-tahoma ttf-vista-fonts cpu-x polybar nutty woeusb nohang-git lightdm-webkit-theme-aether-git debtap rig gimp-plugin-registry vscodium-bin piper
yay -S --needed bitwarden
yay -S --needed pcloud-drive
echo Installed AUR programs

#install wine
echo Installing wine
pacman -S --needed wine-staging giflib lib32-giflib libpng lib32-libpng libldap lib32-libldap gnutls lib32-gnutls mpg123 lib32-mpg123 openal lib32-openal v4l-utils lib32-v4l-utils libpulse lib32-libpulse libgpg-error lib32-libgpg-error alsa-plugins lib32-alsa-plugins alsa-lib lib32-alsa-lib libjpeg-turbo lib32-libjpeg-turbo sqlite lib32-sqlite libxcomposite lib32-libxcomposite libxinerama lib32-libgcrypt libgcrypt lib32-libxinerama ncurses lib32-ncurses opencl-icd-loader lib32-opencl-icd-loader libxslt lib32-libxslt libva lib32-libva gtk3 lib32-gtk3 gst-plugins-base-libs lib32-gst-plugins-base-libs vulkan-icd-loader lib32-vulkan-icd-loader
echo Installed wine

echo Installing python modules
sudo pip3 install ffmpeg-normalize
echo Installed python modules

#Changes to home folder automatically now, no need to be extra careful anymore.
git clone https://gitlab.com/RealStickman-arcolinux/config
echo Finished downloading config

#cleanup
rm -rf ~/setup
echo Removed old setup files

#downloading config
echo Setting config
bash ~/config/install.sh
pkgstats
echo Finished everything
