#!/bin/bash

# TODO make this work
# NOTE ignore errors from missing "||". Try getting the line below to work
#set -euo pipefail

# get current directory
setupdir=$(pwd)

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
            echo "xfce4" >> "$setupdir/selectedpkgs.txt"
            ;;
        2)
            in_i3gaps=1
            echo "i3-gaps" >> "$setupdir/selectedpkgs.txt"
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
            echo "firefox" >> "$setupdir/selectedpkgs.txt"
            ;;
        2)
            in_chromium=1
            echo "chromium" >> "$setupdir/selectedpkgs.txt"
            ;;
        3)
            in_netsurf=1
            echo "netsurf" >> "$setupdir/selectedpkgs.txt"
            ;;
        4)
            in_icecat=1
            echo "icecat-bin" >> "$setupdir/aurselectedpkgs.txt"
            ;;
        5)
            in_tor=1
            echo "torbrowser-launcher" >> "$setupdir/selectedpkgs.txt"
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
in_element=0

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
         14 "Fractal" off
         15 "Bettergram" off
         16 "Waifu2x" off
         17 "Telegram" on
         18 "Element" on)
choices=$("${cmd[@]}" "${options[@]}" 2>&1 >/dev/tty)
clear
for choice in $choices
do
    case $choice in
        1)
            in_virtmanager=1
            printf '%s\n' 'qemu' 'virt-manager' >> "$setupdir/selectedpkgs.txt"
            ;;
        2)
            in_steam=1
            printf '%s\n' 'steam' 'steam-native-runtime' >> "$setupdir/selectedpkgs.txt"
            ;;
        3)
            in_lutris=1
            echo "lutris" >> "$setupdir/selectedpkgs.txt"
            ;;
        4)
            in_blender=1
            echo "blender" >> "$setupdir/selectedpkgs.txt"
            ;;
        5)
            in_krita=1
            echo "krita" >> "$setupdir/selectedpkgs.txt"
            ;;
        6)
            in_youtubedl=1
            echo "youtube-dl" >> "$setupdir/selectedpkgs.txt"
            ;;
        7)
            in_discord=1
            #echo "discord" >> "$setupdir/selectedpkgs.txt"
            echo "discord_arch_electron" >> "$setupdir/aurselectedpkgs.txt"
            ;;
        8)
            in_handbrake=1
            echo "handbrake" >> "$setupdir/selectedpkgs.txt"
            ;;
        9)
            in_gimp=1
            echo "gimp" >> "$setupdir/selectedpkgs.txt"
            ;;
        10)
            in_audacity=1
            echo "audacity" >> "$setupdir/selectedpkgs.txt"
            ;;
        11)
            # REVIEW special case
            in_mangohud=1
            ;;
        12)
            in_easystrokes=1
            echo "easystroke" >> "$setupdir/aurselectedpkgs.txt"
            ;;
        13)
            in_liferea=1
            echo "liferea" >> "$setupdir/aurselectedpkgs.txt"
            ;;
        14)
            in_fractal=1
            echo "fractal" >> "$setupdir/selectedpkgs.txt"
            ;;
        15)
            in_bettergram=1
            echo "bettergram" >> "$setupdir/aurselectedpkgs.txt"
            ;;
        16)
            in_waifu2x=1
            echo "waifu2x-ncnn-vulkan" >> "$setupdir/aurselectedpkgs.txt"
            ;;
        17)
            in_telegram=1
            echo "telegram-desktop" >> "$setupdir/selectedpkgs.txt"
            ;;
        18)
            in_element=1
            echo "element-desktop" >> "$setupdir/selectedpkgs.txt"
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
            echo "auto-cpufreq-git" >> "$setupdir/aurselectedpkgs.txt"
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
            printf '%s\n' 'git' 'emacs' 'ripgrep' 'fd' 'pandoc' 'shellcheck' 'python-pipenv' 'python-isort' 'python-pytest' 'python-rednose' 'pychecker' 'texlive-core' >> "$setupdir/aurselectedpkgs.txt"
            # TODO handle rest of installation
            ;;
        2)
            in_vscodium=1
            echo "vscodium-bin" >> "$setupdir/aurselectedpkgs.txt"
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
            echo "teams" >> "$setupdir/aurselectedpkgs.txt"
            ;;
        2)
            in_slack=1
            #echo "slack-desktop" >> "$setupdir/aurselectedpkgs.txt"
            echo "slack-electron" >> "$setupdir/aurselectedpkgs.txt"
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
            echo "pkgstats" >> "$setupdir/selectedpkgs.txt"
            ;;
    esac
done

# Packages installed on different systems
in_arco_pc=0
in_arco_hp=0

cmd=(dialog --separate-output --checklist "Install system specific packages?" 22 76 16)
options=(1 "Arco PC" off
        2 "Arco HP" off)
choices=$("${cmd[@]}" "${options[@]}" 2>&1 >/dev/tty)
clear
for choice in $choices
do
    case $choice in
        1)
            in_arco_pc=1
            ;;
        2)
            in_arco_hp=1
            ;;
    esac
done

#uninstalling unused packages
echo Uninstalling unused packages
sudo pacman -Rns - < "$setupdir/packages/uninstall.txt"
echo Uninstalled unused packages

#update stuff
echo Updating packages
paru -Syyu
echo Updated packages

#pacman programs
echo Installing default pacman programs
sudo pacman -S --needed - < "$setupdir/packages/officialpkgs.txt"
echo Installed official programs

# audio
echo Installing audio programs
sudo pacman -S --needed - < "$setupdir/packages/audiopkgs.txt"
echo Installed audio programs

# pip
echo Installing python programs
pip install --user autotrash
echo Installed python programs

# setup autotrash
autotrash -d 5 --install
systemctl --user start autotrash
systemctl --user enable autotrash.timer

# REVIEW Patched neofetch version to remove Color codes
git clone https://github.com/RealStickman/neofetch
cd neofetch
sudo make install
cd ..
rm -rf neofetch

# install paru
if [[ $(pacman -Q | grep yay) ]] && [[ ! $(pacman -Q | grep paru) ]]; then
    echo "Installing paru"
    yay -S paru-bin
fi

#AUR
echo Installing default AUR programs
paru -S --needed - < "$setupdir/packages/aurpkgs.txt"
echo Installed AUR programs

# theming
echo Installing themes and icons
paru -S --needed - < "$setupdir/packages/theme-packages.txt"
echo Installed themes and icons

#install wine
echo Installing wine
sudo pacman -S --needed - < "$setupdir/packages/winepkgs.txt"
echo Installed wine

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
    #sudo pacman -S --needed discord
    paru -S discord_arch_electron
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

if [ $in_element -eq 1 ]; then
    echo "Installing Element"
    sudo pacman -S --needed element-desktop
else
    echo "Skipping Element"
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
    #paru -S --needed slack-desktop
    paru -s --needed slack-electron
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

# other system configs
# arco pc
if [ $in_arco_pc -eq 1 ]; then
    echo "Installing arco pc packages"
    paru -S --needed - < "$setupdir/packages/arco-pc-packages.txt"
fi

# arco hp
if [ $in_arco_hp -eq 1 ]; then
    echo "Installing arch hp packages"
    paru -S --needed - < "$setupdir/packages/arch-hp-packages.txt"
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

# enable lightdm
sudo systemctl enable lightdm

# update fonts cache
fc-cache -f

# download grub theme
git clone https://github.com/xenlism/Grub-themes.git
cd "Grub-themes/xenlism-grub-arch-1080p/"
sudo bash install.sh
# go back
cd ../../

#Changes to home folder automatically now, no need to be extra careful anymore.
git clone https://gitlab.com/RealStickman-arch/config
echo Finished downloading config

# Download git repos
bash ~/config/scripts/sc-git-pull

#cleanup
rm -rf ~/setup
echo Removed setup files

#downloading config
echo Setting config
bash ~/config/install.sh

if [[ $(pacman -Q pkgstats 2>/dev/null > /dev/null) ]]; then
    pkgstats
fi

echo Finished everything
exit 0
