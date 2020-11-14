#!/bin/bash

# TODO make this work
# NOTE ignore errors from missing "||". Try getting the line below to work
#set -euo pipefail

#change to home (does not show in terminal)
cd "$HOME"

in_xfce=0
in_i3gaps=0

cmd=(dialog --separate-output --checklist "Select Desktop environment/Window manager:" 22 76 16)
options=(1 "[DE] xfce4" off    # any option can be set to default to "on"
         2 "[WM] i3-gaps" off)
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
    esac
done

in_firefox=0
in_chromium=0
in_netsurf=0
in_icecat=0
in_tor=0

cmd=(dialog --separate-output --checklist "Select browsers:" 22 76 16)
options=(1 "Firefox" on    # any option can be set to default to "on"
         2 "Chromium" off
         3 "Netsurf" off
         4 "Icecat" off
         5 "Torbrowser" on)
choices=$("${cmd[@]}" "${options[@]}" 2>&1 >/dev/tty)
clear
for choice in $choices
do
    case $choice in
        1)
            in_firefox=1
            ;;
        2)
            in_chromium=1
            ;;
        3)
            in_netsurf=1
            ;;
        4)
            in_icecat=1
            ;;
        5)
            in_tor=1
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
in_waifu2x=0

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
         15 "Bettergram" on
         16 "Waifu2x" off)
choices=$("${cmd[@]}" "${options[@]}" 2>&1 >/dev/tty)
clear
for choice in $choices
do
    case $choice in
        1)
            in_virtmanager=1
            ;;
        2)
            in_steam=1
            ;;
        3)
            in_lutris=1
            ;;
        4)
            in_blender=1
            ;;
        5)
            in_krita=1
            ;;
        6)
            in_youtubedl=1
            ;;
        7)
            in_discord=1
            ;;
        8)
            in_handbrake=1
            ;;
        9)
            in_gimp=1
            ;;
        10)
            in_audacity=1
            ;;
        11)
            in_mangohud=1
            ;;
        12)
            in_easystrokes=1
            ;;
        13)
            in_liferea=1
            ;;
        14)
            in_mirage=1
            ;;
        15)
            in_bettergram=1
            ;;
        16)
            in_waifu2x=1
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

in_teams=0
in_slack=0

cmd=(dialog --separate-output --checklist "School and work communication" 22 76 16)
options=(1 "teams" off
        2 "slack" off)
choices=$("${cmd[@]}" "${options[@]}" 2>&1 >/dev/tty)
clear
for choice in $choices
do
    case $choice in
        1)
            in_teams=1
            ;;
        2)
            in_slack=1
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

# Additional, only once installed, packages
in_optpkg=0

cmd=(dialog --separate-output --checklist "Report installed packages?" 22 76 16)
options=(1 "Additional packages" off)
choices=$("${cmd[@]}" "${options[@]}" 2>&1 >/dev/tty)
clear
for choice in $choices
do
    case $choice in
        1)
            in_optpkg=1
            ;;
    esac
done

#uninstalling unused packages
echo Uninstalling unused packages
sudo pacman -Rns evolution catfish geany vim keepass gnome-boxes sublime-text-dev atom adwaita-icon-theme arcolinux-i3wm-git arcolinux-tweak-tool-git arcolinux-welcome-app-git clonezilla evolution-data-server numix-circle-arc-icons-git numix-circle-icon-theme-git numix-gtk-theme-git numix-icon-theme-git oh-my-zsh-git pamac-aur qbittorrent vivaldi vlc code baka-mplayer tmux guvcview kdenlive xfce4-notifyd chromium psensor transmission-qt pcloud-drive
echo Uninstalled unused packages

#update stuff
echo Updating packages
paru -Syyu
echo Updated packages

#pacman programs
echo Installing default pacman programs
sudo pacman -S --needed arandr libreoffice-fresh-de termite wget picom stress obs-studio python-pip hunspell hunspell-de hunspell-en_GB hyphen hyphen-de hyphen-en fish smartmontools thunderbird ffmpeg jre-openjdk thunar gtk-engine-murrine celluloid languagetool rofi nextcloud-client vnstat wireguard-tools cronie libnotify notification-daemon dunst rsync restic piper lightdm-gtk-greeter unzip ranger bandwhich cmus xorg-xrdb variety nitrogen feh gnome-keyring xorg-xbacklight
#audio
sudo pacman -S --needed pavucontrol pulseaudio pulseaudio-alsa pulseaudio-bluetooth libpulse alsa-card-profiles libcanberra-pulse lib32-libpulse pulseaudio-equalizer-ladspa
# REVIEW replace transmission-qt with gtk version
sudo pacman -S --needed transmission-gtk
# REVIEW maybe find theme with less dependencies
sudo pacman -S --needed breeze

# NOTE Distro specific stuff
distro=$(cat /etc/*-release | grep "^ID=")
if [ "$distro" == "ID=arcolinux" ]; then
    sudo pacman -S --needed arcolinux-slim arcolinux-slimlock-themes-git
fi
if [ "$distro" == "ID=arch" ]; then
    sudo pacman -S --needed slim archlinux-themes-slim
fi
echo Installed official programs

# REVIEW Determine usefulness
# iperf3
# nload
# dmenu
# devtools

# REVIEW Patched neofetch version to remove Color codes
git clone https://github.com/RealStickman/neofetch
cd neofetch
sudo make install
cd ..
rm -rf neofetch

#AUR
echo Installing default AUR programs
paru -S --needed ttf-ms-fonts ttf-vista-fonts polybar nohang-git lightdm-webkit-theme-aether rig tmpmail-git lightdm-webkit2-theme-glorious sweet-theme-dark sweet-folders-icons-git wps-office protonmail-bridge
#paru -S --needed freetype2-cleartype
sudo pacman -S --needed freetype2
paru -S --needed bitwarden
#paru -S --needed --noconfirm pcloud-drive
echo Installed AUR programs

# REVIEW Determine usefulness
# ttf-tahoma
# cpu-x
# nutty
# woeusb
# debtap
# gimp-plugin-registry
# multimc5

#install wine
echo Installing wine
pacman -S --needed wine-staging giflib lib32-giflib libpng lib32-libpng libldap lib32-libldap gnutls lib32-gnutls mpg123 lib32-mpg123 openal lib32-openal v4l-utils lib32-v4l-utils libpulse lib32-libpulse libgpg-error lib32-libgpg-error alsa-plugins lib32-alsa-plugins alsa-lib lib32-alsa-lib libjpeg-turbo lib32-libjpeg-turbo sqlite lib32-sqlite libxcomposite lib32-libxcomposite libxinerama lib32-libgcrypt libgcrypt lib32-libxinerama ncurses lib32-ncurses opencl-icd-loader lib32-opencl-icd-loader libxslt lib32-libxslt libva lib32-libva gtk3 lib32-gtk3 gst-plugins-base-libs lib32-gst-plugins-base-libs vulkan-icd-loader lib32-vulkan-icd-loader os-prober
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
    sudo pacman -S --needed i3-gaps
else   
    echo "Skipping i3-gaps"
fi

#browsers
if [ $in_firefox -eq 1 ]; then
    echo "Installing Firefox"
    sudo pacman -S --needed --noconfirm qemu firefox
else
    echo "Skipping Firefox"
fi

if [ $in_chromium -eq 1 ]; then
    echo "Installing Chromium"
    sudo pacman -S --needed --noconfirm chromium
else
    echo "Skipping Chromium"
fi

if [ $in_netsurf -eq 1 ]; then
    echo "Installing Netsurf"
    sudo pacman -S --needed --noconfirm netsurf
else
    echo "Skipping Netsurf"
fi

if [ $in_icecat -eq 1 ]; then
    echo "Installing Icecat"
    sudo paru -S --needed --noconfirm icecat-bin
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
    paru -S --needed --noconfirm easystroke
else
    echo "Skipping Easystrokes"
fi

if [ $in_liferea -eq 1 ]; then
    echo "Installing Liferea"
    paru -S --needed --noconfirm liferea
else
    echo "Skipping Liferea"
fi

if [ $in_mirage -eq 1 ]; then
    echo "Installing Mirage"
    paru -S --needed --noconfirm matrix-mirage
else
    echo "Skipping Mirage"
fi

if [ $in_bettergram -eq 1 ]; then
    echo "Installing Bettergram"
    paru -S --needed --noconfirm bettergram
else
    echo "Skipping Bettergram"
fi

if [ $in_waifu2x -eq 1 ]; then
    echo "Installing Waifu2x"
    paru -S --needed --noconfirm waifu2x-ncnn-vulkan
else
    echo "Skipping Waifu2x"
fi

#performance and battery life
if [ $in_acpufreq -eq 1 ]; then
    echo "Installing auto-cpufreq"
    paru -S --needed --noconfirm auto-cpufreq-git
    sudo auto-cpufreq --install
    sudo systemctl start auto-cpufreq
    sudo systemctl enable auto-cpufreq
else
    echo "Skipping auto-cpufreq"
fi

#text editors
if [ $in_doomemacs -eq 1 ]; then
    echo "Installing doom-emacs"
    paru -S --needed --noconfirm git emacs ripgrep fd pandoc shellcheck python-pipenv python-isort python-pytest python-rednose pychecker texlive-core
    git clone --depth 1 https://github.com/hlissner/doom-emacs ~/.emacs.d
    ~/.emacs.d/bin/doom install
    export PATH="$PATH":$HOME/.emacs.d/bin
else
    echo "Skipping doom-emacs"
fi

if [ $in_vscodium -eq 1 ]; then
    echo "Installing vscodium"
    paru -S --needed --noconfirm vscodium-bin
else
    echo "Skipping vscodium"
fi

#other social stuff
if [ $in_teams -eq 1 ]; then
    echo "Installing teams"
    paru -S --needed --noconfirm teams
else
    echo "Skipping teams"
fi

if [ $in_slack -eq 1 ]; then
    echo "Installing slack"
    paru -S --needed --noconfirm slack-desktop
else
    echo "Skipping slack"
fi

#stats
if [ $in_pkgstats -eq 1 ]; then
    echo "Installing pkgstats"
    sudo pacman -S --needed --noconfirm pkgstats
else
    echo "Skipping pkgstats"
fi

# additional packages
if [ $in_optpkg -eq 1 ]; then
    echo "Installing additional packages"
    paru -S --needed - < "$HOME/setup/pkglist.txt"
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
