#!/bin/bash

set -euo pipefail

#change to home (does not show in terminal)
cd "$HOME"

in_xfce=0
in_i3gaps=0
in_gnome=0

cmd=(dialog --separate-output --checklist "Select Desktop environment/Window manager:" 22 76 16)
options=(1 "[DE] xfce4" off    # any option can be set to default to "on"
         2 "[WM] i3-gaps" off
         3 "[DE] gnome" off)
choices=$("${cmd[@]}" "${options[@]}" 2>&1 >/dev/tty)
clear
for choice in $choices
do
    case $choice in
        1)
            in_xfce=1
            ;;
        2)
            in_i3gaps=1
            ;;
        3)
            in_gnome=1
            ;;
    esac
done

in_firefox=0
in_ugchromium=0
in_palemoon=0
in_basilisk=0
in_netsurf=0
in_icecat=0
in_tor=0

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
            in_firefox=1
            echo Installed Firefox
            ;;
        2)
            in_ugchromium=1
            echo Installed Ungoogled-Chromium
            ;;
        3)
            in_palemoon=1
            echo Installed Palemoon
            ;;
        4)
            in_basilisk=1
            echo Installed Basilisk
            ;;
        5)
            in_netsurf=1
            echo Installed Netsurf
            ;;
        6)
            in_icecat=1
            echo Installed Icecat
            ;;
        7)
            in_tor=1
            echo Installed Torbrowser
            ;;
    esac
done

in_virtmanager=0
in_steam=0
in_lutris=0
in_blender=0
in_krita=0
in_youtubedl=0
in_discord=0
in_handbrake=0
in_gimp=0
in_audacity=0
in_mangohud=0
in_easystrokes=0
in_liferea=0
in_mirage=0
in_bettergram=0

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
         14 "Mirage" on
         15 "Bettergram" on)
choices=$("${cmd[@]}" "${options[@]}" 2>&1 >/dev/tty)
clear
for choice in $choices
do
    case $choice in
        1)
            in_virtmanager=1
            echo Installed VirtManager
            ;;
        2)
            in_steam=1
            echo Installed Steam
            ;;
        3)
            in_lutris=1
            echo Installed Lutris
            ;;
        4)
            in_blender=1
            echo Installed Blender
            ;;
        5)
            in_krita=1
            echo Installed Krita
            ;;
        6)
            in_youtubedl=1
            echo Installed Youtube-dl
            ;;
        7)
            in_discord=1
            echo Installed Discord
            ;;
        8)
            in_handbrake=1
            echo Installed Handbrake
            ;;
        9)
            sudo pacman -S --needed gimp
            echo Installed Gimp
            ;;
        10)
            in_audacity=1
            echo Installed Audacity
            ;;
        11)
            in_mangohud=1
            echo Installed MangoHud
            ;;
        12)
            in_easystrokes=1
            echo Installed Easystroke
            ;;
        13)
            in_liferea=1
            echo Installed Liferea
            ;;
        14)
            in_mirage=1
            echo Installed Mirage
            ;;
        15)
            in_bettergram=1
            echo Installed Bettergram
            ;;
    esac
done

in_acpufreq=0

cmd=(dialog --separate-output --checklist "Performance and Battery life" 22 76 16)
options=(1 "auto-cpufreq" off)
choices=$("${cmd[@]}" "${options[@]}" 2>&1 >/dev/tty)
clear
for choice in $choices
do
    case $choice in
        1)
            in_acpufreq=1
            ;;
    esac
done

in_doomemacs=0
in_vscodium=0

cmd=(dialog --separate-output --checklist "Code editors" 22 76 16)
options=(1 "doom-emacs" off
        2 "vscodium" off)
choices=$("${cmd[@]}" "${options[@]}" 2>&1 >/dev/tty)
clear
for choice in $choices
do
    case $choice in
        1)
            in_doomemacs=1
            ;;
        2)
            in_vscodium=1
            ;;
    esac
done

in_pkgstats=0

cmd=(dialog --separate-output --checklist "Report installed packages?" 22 76 16)
options=(1 "pkgstats" off)
choices=$("${cmd[@]}" "${options[@]}" 2>&1 >/dev/tty)
clear
for choice in $choices
do
    case $choice in
        1)
            in_pkgstats=1
            ;;
    esac
done

#uninstalling unused packages
echo Uninstalling unused packages
sudo pacman -Rns --noconfirm evolution catfish geany vim keepass gnome-boxes sublime-text-dev atom adwaita-icon-theme arcolinux-i3wm-git arcolinux-tweak-tool-git arcolinux-welcome-app-git clonezilla evolution-data-server numix-circle-arc-icons-git numix-circle-icon-theme-git numix-gtk-theme-git numix-icon-theme-git oh-my-zsh-git pamac-aur qbittorrent vivaldi vlc code baka-mplayer tmux guvcview kdenlive xfce4-notifyd
echo Uninstalled unused packages

#update stuff
echo Updating packages
yay -Syyu --noconfirm 
echo Updated packages

#pacman programs
echo Installing default pacman programs
sudo pacman -S --needed --noconfirm arandr libreoffice-fresh-de termite neofetch wget picom stress obs-studio  python-pip hunspell hunspell-de hyphen hyphen-de fish psensor transmission-qt smartmontools thunderbird ffmpeg jre-openjdk thunar gtk-engine-murrine iperf3 celluloid nload languagetool dmenu rofi nextcloud-client devtools arcolinux-slim arcolinux-slimlock-themes-git vnstat wireguard-tools cronie bandwhich libnotify notification-daemon dunst breeze
echo Installed official programs

#AUR
echo Installing default AUR programs
yay -S --needed --noconfirm ttf-ms-fonts ttf-tahoma ttf-vista-fonts cpu-x polybar nutty woeusb nohang-git lightdm-webkit-theme-aether debtap rig gimp-plugin-registry piper
yay -S --needed --noconfirm bitwarden
yay -S --needed --noconfirm pcloud-drive
echo Installed AUR programs

#install wine
echo Installing wine
pacman -S --needed --noconfirm wine-staging giflib lib32-giflib libpng lib32-libpng libldap lib32-libldap gnutls lib32-gnutls mpg123 lib32-mpg123 openal lib32-openal v4l-utils lib32-v4l-utils libpulse lib32-libpulse libgpg-error lib32-libgpg-error alsa-plugins lib32-alsa-plugins alsa-lib lib32-alsa-lib libjpeg-turbo lib32-libjpeg-turbo sqlite lib32-sqlite libxcomposite lib32-libxcomposite libxinerama lib32-libgcrypt libgcrypt lib32-libxinerama ncurses lib32-ncurses opencl-icd-loader lib32-opencl-icd-loader libxslt lib32-libxslt libva lib32-libva gtk3 lib32-gtk3 gst-plugins-base-libs lib32-gst-plugins-base-libs vulkan-icd-loader lib32-vulkan-icd-loader
echo Installed wine

#python modules
echo Installing python modules
sudo pip3 install ffmpeg-normalize praw
echo Installed python modules

###################
#selected programs#
###################
echo Installing selected programs

#DEs & WMs
if [ $in_xfce -eq 1 ]; then
    echo "Installing xfce"
    sudo pacman -S --needed --noconfirm xfce4
else
    echo "Skipping xfce"
fi

if [ $in_i3gaps -eq 1 ]; then
    echo "Installing i3-gaps"
    sudo pacman -S --needed --noconfirm i3-gaps
else   
    echo "Skipping i3-gaps"
fi

if [ $in_gnome -eq 1 ]; then
    echo "Installing gnome"
    sudo yay -S --needed --noconfirm gnome gnome-shell-extension-arc-menu gnome-shell-extension-dash-to-dock gnome-tweaks
else
    echo "Skipping gnome"
fi

#browsers
if [ $in_firefox -eq 1 ]; then
    echo "Installing Firefox"
    sudo pacman -S --needed --noconfirm qemu firefox
else
    echo "Skipping Firefox"
fi

if [ $in_ugchromium -eq 1 ]; then
    echo "Installing Ungoogled-chromium"
    sudo pacman -S --needed --noconfirm ungoogled-chromium
else
    echo "Skipping Ungoogled-chromium"
fi

if [ $in_palemoon -eq 1 ]; then
    echo "Installing Palemoon"
    sudo pacman -S --needed --noconfirm palemoon
else
    echo "Skipping Palemoon"
fi

if [ $in_basilisk -eq 1 ]; then
    echo "Installing Basilisk"
    sudo pacman -S --needed --noconfirm basilisk
else
    echo "Skipping Basilisk"
fi

if [ $in_netsurf -eq 1 ]; then
    echo "Installing Netsurf"
    sudo pacman -S --needed --noconfirm netsurf
else
    echo "Skipping Netsurf"
fi

if [ $in_icecat -eq 1 ]; then
    echo "Installing Icecat"
    sudo yay -S --needed --noconfirm icecat-bin
else
    echo "Skipping Icecat"
fi

if [ $in_tor -eq 1 ]; then
    echo "Installing Tor"
    sudo pacman -S --needed --noconfirm torbrowser-launcher
else
    echo "Skipping Tor"
fi

#other programs
if [ $in_virtmanager -eq 1 ]; then
    echo "Installing VirtManager"
    sudo pacman -S --needed --noconfirm qemu virt-manager
else
    echo "Skipping VirtManager"
fi

if [ $in_steam -eq 1 ]; then
    echo "Installing Steam"
    sudo pacman -S --needed --noconfirm steam steam-native-runtime
else
    echo "Skipping Steam"
fi

if [ $in_lutris -eq 1 ]; then
    echo "Installing Lutris"
    sudo pacman -S --needed --noconfirm lutris
else
    echo "Skipping Lutris"
fi

if [ $in_blender -eq 1 ]; then
    echo "Installing Blender"
    sudo pacman -S --needed --noconfirm blender
else
    echo "Skipping Blender"
fi

if [ $in_krita -eq 1 ]; then
    echo "Installing Krita"
    sudo pacman -S --needed --noconfirm krita
else
    echo "Skipping Krita"
fi

if [ $in_youtubedl -eq 1 ]; then
    echo "Installing Youtube-dl"
    sudo pacman -S --needed --noconfirm youtube-dl
else
    echo "Skipping Youtube-dl"
fi

if [ $in_discord -eq 1 ]; then
    echo "Installing Discord"
    sudo pacman -S --needed --noconfirm discord
else
    echo "Skipping Discord"
fi

if [ $in_handbrake -eq 1 ]; then
    echo "Installing Handbrake"
    sudo pacman -S --needed --noconfirm handbrake
else
    echo "Skipping Handbrake"
fi

if [ $in_gimp -eq 1 ]; then
    echo "Installing Gimp"
    sudo pacman -S --needed --noconfirm gimp
else
    echo "Skipping Gimp"
fi

if [ $in_audacity -eq 1 ]; then
    echo "Installing Audacity"
    sudo pacman -S --needed --noconfirm audacity
else
    echo "Skipping Audacity"
fi

if [ $in_mangohud -eq 1 ]; then
    echo "Installing MangoHud"
    git clone --recurse-submodules https://github.com/flightlessmango/MangoHud.git
    ./MangoHud/build.sh install
else
    echo "Skipping MangoHud"
fi

if [ $in_easystrokes -eq 1 ]; then
    echo "Installing Easystrokes"
    sudo yay -S --needed --noconfirm easystroke
else
    echo "Skipping Easystrokes"
fi

if [ $in_liferea -eq 1 ]; then
    echo "Installing Liferea"
    sudo yay -S --needed --noconfirm liferea
else
    echo "Skipping Liferea"
fi

if [ $in_mirage -eq 1 ]; then
    echo "Installing Mirage"
    sudo yay -S --needed --noconfirm matrix-mirage
else
    echo "Skipping Mirage"
fi

if [ $in_bettergram -eq 1 ]; then
    echo "Installing Bettergram"
    sudo yay -S --needed --noconfirm bettergram
else
    echo "Skipping Bettergram"
fi

#performance and battery life
if [ $in_acpufreq -eq 1 ]; then
    echo "Installing auto-cpufreq"
    sudo yay -S --needed --noconfirm auto-cpufreq-git
    sudo auto-cpufreq --install
    sudo systemctl start auto-cpufreq
    sudo systemctl enable auto-cpufreq
else
    echo "Skipping auto-cpufreq"
fi

#doom-emacs
if [ $in_doomemacs -eq 1 ]; then
    echo "Installing doom-emacs"
    yay -S --needed --noconfirm git emacs ripgrep fd pandoc shellcheck python-pipenv python-isort python-pytest python-rednose pychecker texlive-core
    git clone --depth 1 https://github.com/hlissner/doom-emacs ~/.emacs.d
    ~/.emacs.d/bin/doom install
    export PATH="$PATH":$HOME/.emacs.d/bin
else
    echo "Skipping doom-emacs"
fi

if [ $in_vscodium -eq 1 ]; then
    echo "Installing vscodium"
    yay -S --needed --noconfirm vscodium-bin
else
    echo "Skipping vscodium"
fi

#stats
if [ $in_pkgstats -eq 1 ]; then
    echo "Installing pkgstats"
    sudo pacman -S --needed --noconfirm pkgstats
else
    echo "Skipping pkgstats"
fi

#change shell
chsh -s /usr/bin/fish "$USER"

#enable vnstat
sudo systemctl enable vnstat
sudo systemctl start vnstat

#Changes to home folder automatically now, no need to be extra careful anymore.
git clone https://gitlab.com/RealStickman-arcolinux/config
echo Finished downloading config

#cleanup
rm -rf ~/setup
echo Removed setup files

#downloading config
echo Setting config
bash ~/config/install.sh
pkgstats
echo Finished everything
