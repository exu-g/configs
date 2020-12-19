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
            echo "xfce4" >> selectedpkgs.txt
            ;;
        2)
            in_i3gaps=1
            echo "i3-gaps" >> selectedpkgs.txt
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
            echo "firefox" >> selectedpkgs.txt
            ;;
        2)
            in_chromium=1
            echo "chromium" >> selectedpkgs.txt
            ;;
        3)
            in_netsurf=1
            echo "netsurf" >> selectedpkgs.txt
            ;;
        4)
            in_icecat=1
            echo "icecat-bin" >> aurselectedpkgs.txt
            ;;
        5)
            in_tor=1
            echo "torbrowser-launcher" >> selectedpkgs.txt
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
in_fractal=0
in_bettergram=0
in_waifu2x=0
in_telegram=0

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
         14 "Fractal" on
         15 "Bettergram" off
         16 "Waifu2x" off
         17 "Telegram" on)
choices=$("${cmd[@]}" "${options[@]}" 2>&1 >/dev/tty)
clear
for choice in $choices
do
    case $choice in
        1)
            in_virtmanager=1
            printf '%s\n' 'qemu' 'virt-manager' >> selectedpkgs.txt
            ;;
        2)
            in_steam=1
            printf '%s\n' 'steam' 'steam-native-runtime' >> selectedpkgs.txt
            ;;
        3)
            in_lutris=1
            echo "lutris" >> selectedpkgs.txt
            ;;
        4)
            in_blender=1
            echo "blender" >> selectedpkgs.txt
            ;;
        5)
            in_krita=1
            echo "krita" >> selectedpkgs.txt
            ;;
        6)
            in_youtubedl=1
            echo "youtube-dl" >> selectedpkgs.txt
            ;;
        7)
            in_discord=1
            echo "discord" >> selectedpkgs.txt
            ;;
        8)
            in_handbrake=1
            echo "handbrake" >> selectedpkgs.txt
            ;;
        9)
            in_gimp=1
            echo "gimp" >> selectedpkgs.txt
            ;;
        10)
            in_audacity=1
            echo "audacity" >> selectedpkgs.txt
            ;;
        11)
            # REVIEW special case
            in_mangohud=1
            ;;
        12)
            in_easystrokes=1
            echo "easystroke" >> aurselectedpkgs.txt
            ;;
        13)
            in_liferea=1
            echo "liferea" >> aurselectedpkgs.txt
            ;;
        14)
            in_fractal=1
            echo "fractal" >> selectedpkgs.txt
            ;;
        15)
            in_bettergram=1
            echo "bettergram" >> aurselectedpkgs.txt
            ;;
        16)
            in_waifu2x=1
            echo "waifu2x-ncnn-vulkan" >> aurselectedpkgs.txt
            ;;
        17)
            in_telegram=1
            echo "telegram-desktop" >> selectedpkgs.txt
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
            echo "auto-cpufreq-git" >> aurselectedpkgs.txt
            # TODO Handle rest of installation
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
            # TODO sort pacman and AUR packages
            printf '%s\n' 'git' 'emacs' 'ripgrep' 'fd' 'pandoc' 'shellcheck' 'python-pipenv' 'python-isort' 'python-pytest' 'python-rednose' 'pychecker' 'texlive-core' >> aurselectedpkgs.txt
            # TODO handle rest of installation
            ;;
        2)
            in_vscodium=1
            echo "vscodium-bin" >> aurselectedpkgs.txt
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
            echo "teams" >> aurselectedpkgs.txt
            ;;
        2)
            in_slack=1
            echo "slack-desktop" >> aurselectedpkgs.txt
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
            echo "pkgstats" >> selectedpkgs.txt
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
#sudo pacman -Rns evolution catfish geany vim keepass gnome-boxes sublime-text-dev atom adwaita-icon-theme arcolinux-i3wm-git arcolinux-tweak-tool-git arcolinux-welcome-app-git clonezilla evolution-data-server numix-circle-arc-icons-git numix-circle-icon-theme-git numix-gtk-theme-git numix-icon-theme-git oh-my-zsh-git pamac-aur qbittorrent vivaldi vlc code baka-mplayer tmux guvcview kdenlive xfce4-notifyd chromium psensor transmission-qt pcloud-drive matrix-mirage element-desktop pulseaudio-equalizer-ladspa
sudo pacman -Rns - < "$HOME/setup/uninstall.txt"
echo Uninstalled unused packages

#update stuff
echo Updating packages
paru -Syyu
echo Updated packages

#pacman programs
echo Installing default pacman programs
sudo pacman -S --needed - < "$HOME/setup/officialpkgs.txt"
#sudo pacman -S --needed --noconfirm transmission-gtk
#sudo pacman -S --needed --noconfirm noto-fonts noto-fonts-emoji
#sudo pacman -S --needed --noconfirm ufw
#sudo pacman -S --needed --noconfirm freetype2

# NOTE Distro specific stuff
#distro=$(cat /etc/*-release | grep "^ID=")
#if [ "$distro" == "ID=arcolinux" ]; then
#    sudo pacman -R slim archlinux-themes-slim
#    sudo pacman -S --needed arcolinux-slim arcolinux-slimlock-themes-git
#fi
#if [ "$distro" == "ID=arch" ]; then
#    sudo pacman -R arcolinux-slim arcolinux-slimlock-themes-git
#    sudo pacman -S --needed slim archlinux-themes-slim
#fi
echo Installed official programs

# audio
echo Installing audio programs
#sudo pacman -S --needed --noconfirm pavucontrol pulseaudio pulseaudio-alsa pulseaudio-bluetooth libpulse alsa-card-profiles libcanberra-pulse lib32-libpulse pulseeffects
sudo pacman -S --needed - < "$HOME/setup/audiopkgs.txt"
echo Installed audio programs

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

# install paru
if [[ $(pacman -Q | grep yay) ]] && [[ ! $(pacman -Q | grep paru) ]]; then
    echo "Installing paru"
    yay -S paru
fi

#AUR
echo Installing default AUR programs
paru -S --needed - < "$HOME/setup/aurpkgs.txt"
#paru -S --needed freetype2-cleartype
#paru -S --needed --noconfirm bitwarden
#paru -S --needed --noconfirm pcloud-drive
#paru -S --needed --noconfirm betterlockscreen
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
#sudo pacman -S --needed wine-staging giflib lib32-giflib libpng lib32-libpng libldap lib32-libldap gnutls lib32-gnutls mpg123 lib32-mpg123 openal lib32-openal v4l-utils lib32-v4l-utils libpulse lib32-libpulse libgpg-error lib32-libgpg-error alsa-plugins lib32-alsa-plugins alsa-lib lib32-alsa-lib libjpeg-turbo lib32-libjpeg-turbo sqlite lib32-sqlite libxcomposite lib32-libxcomposite libxinerama lib32-libgcrypt libgcrypt lib32-libxinerama ncurses lib32-ncurses opencl-icd-loader lib32-opencl-icd-loader libxslt lib32-libxslt libva lib32-libva gtk3 lib32-gtk3 gst-plugins-base-libs lib32-gst-plugins-base-libs vulkan-icd-loader lib32-vulkan-icd-loader os-prober
sudo pacman -S --needed - < "$HOME/setup/winepkgs.txt"
echo Installed wine

#python modules
#echo Installing python modules
#sudo pip3 install
#echo Installed python modules

###################
#selected programs#
###################
echo Installing selected programs

#DEs & WMs
if [ $in_xfce -eq 1 ]; then
    echo "Installing xfce"
    sudo pacman -S --needed xfce4
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
    sudo pacman -S --needed firefox
else
    echo "Skipping Firefox"
fi

if [ $in_chromium -eq 1 ]; then
    echo "Installing Chromium"
    sudo pacman -S --needed chromium
else
    echo "Skipping Chromium"
fi

if [ $in_netsurf -eq 1 ]; then
    echo "Installing Netsurf"
    sudo pacman -S --needed netsurf
else
    echo "Skipping Netsurf"
fi

if [ $in_icecat -eq 1 ]; then
    echo "Installing Icecat"
    paru -S --needed icecat-bin
else
    echo "Skipping Icecat"
fi

if [ $in_tor -eq 1 ]; then
    echo "Installing Tor"
    sudo pacman -S --needed torbrowser-launcher
else
    echo "Skipping Tor"
fi

#other programs
if [ $in_virtmanager -eq 1 ]; then
    echo "Installing VirtManager"
    sudo pacman -S --needed qemu virt-manager
else
    echo "Skipping VirtManager"
fi

if [ $in_steam -eq 1 ]; then
    echo "Installing Steam"
    sudo pacman -S --needed steam steam-native-runtime
else
    echo "Skipping Steam"
fi

if [ $in_lutris -eq 1 ]; then
    echo "Installing Lutris"
    sudo pacman -S --needed lutris
else
    echo "Skipping Lutris"
fi

if [ $in_blender -eq 1 ]; then
    echo "Installing Blender"
    sudo pacman -S --needed blender
else
    echo "Skipping Blender"
fi

if [ $in_krita -eq 1 ]; then
    echo "Installing Krita"
    sudo pacman -S --needed krita
else
    echo "Skipping Krita"
fi

if [ $in_youtubedl -eq 1 ]; then
    echo "Installing Youtube-dl"
    sudo pacman -S --needed youtube-dl
else
    echo "Skipping Youtube-dl"
fi

if [ $in_discord -eq 1 ]; then
    echo "Installing Discord"
    sudo pacman -S --needed discord
else
    echo "Skipping Discord"
fi

if [ $in_handbrake -eq 1 ]; then
    echo "Installing Handbrake"
    sudo pacman -S --needed handbrake
else
    echo "Skipping Handbrake"
fi

if [ $in_gimp -eq 1 ]; then
    echo "Installing Gimp"
    sudo pacman -S --needed gimp
else
    echo "Skipping Gimp"
fi

if [ $in_audacity -eq 1 ]; then
    echo "Installing Audacity"
    sudo pacman -S --needed audacity
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
    paru -S --needed easystroke
else
    echo "Skipping Easystrokes"
fi

if [ $in_liferea -eq 1 ]; then
    echo "Installing Liferea"
    paru -S --needed liferea
else
    echo "Skipping Liferea"
fi

if [ $in_fractal -eq 1 ]; then
    echo "Installing Fractal"
    sudo pacman -S --needed fractal
else
    echo "Skipping Fractal"
fi

if [ $in_bettergram -eq 1 ]; then
    echo "Installing Bettergram"
    paru -S --needed bettergram
else
    echo "Skipping Bettergram"
fi

if [ $in_waifu2x -eq 1 ]; then
    echo "Installing Waifu2x"
    paru -S --needed waifu2x-ncnn-vulkan
else
    echo "Skipping Waifu2x"
fi

if [ $in_telegram -eq 1 ]; then
    echo "Installing Telegram"
    sudo pacman -S --needed telegram-desktop
else
    echo "Skipping Telegram"
fi

#performance and battery life
if [ $in_acpufreq -eq 1 ]; then
    echo "Installing auto-cpufreq"
    paru -S --needed auto-cpufreq-git
    sudo auto-cpufreq --install
    sudo systemctl start auto-cpufreq
    sudo systemctl enable auto-cpufreq
else
    echo "Skipping auto-cpufreq"
fi

#text editors
if [ $in_doomemacs -eq 1 ]; then
    echo "Installing doom-emacs"
    paru -S --needed git emacs ripgrep fd pandoc shellcheck python-pipenv python-isort python-pytest python-rednose pychecker texlive-core
    git clone --depth 1 https://github.com/hlissner/doom-emacs ~/.emacs.d
    ~/.emacs.d/bin/doom install
    export PATH="$PATH":$HOME/.emacs.d/bin
else
    echo "Skipping doom-emacs"
fi

if [ $in_vscodium -eq 1 ]; then
    echo "Installing vscodium"
    paru -S --needed vscodium-bin
else
    echo "Skipping vscodium"
fi

#other social stuff
if [ $in_teams -eq 1 ]; then
    echo "Installing teams"
    paru -S --needed teams
else
    echo "Skipping teams"
fi

if [ $in_slack -eq 1 ]; then
    echo "Installing slack"
    paru -S --needed slack-desktop
else
    echo "Skipping slack"
fi

#stats
if [ $in_pkgstats -eq 1 ]; then
    echo "Installing pkgstats"
    sudo pacman -S --needed pkgstats
else
    echo "Skipping pkgstats"
fi

# additional packages
if [ $in_optpkg -eq 1 ]; then
    echo "Installing additional packages"
    paru -S --needed - < "$HOME/setup/optpkglist.txt"
fi

#change shell
chsh -s /usr/bin/fish "$USER"

#enable vnstat
sudo systemctl enable vnstat
sudo systemctl start vnstat

# enable firewall
echo "Enabling Firewall"
sudo ufw enable
sudo systemctl enable ufw
sudo systemctl start ufw

#Changes to home folder automatically now, no need to be extra careful anymore.
git clone https://gitlab.com/RealStickman-arcolinux/config
echo Finished downloading config

# Download git repos
bash ~/config/scripts/sc-git-pull

#cleanup
rm -rf ~/setup
echo Removed setup files

#downloading config
echo Setting config
bash ~/config/install.sh
pkgstats
echo Finished everything
exit 0
