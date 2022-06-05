#!/bin/bash

set -euo pipefail

# get script directory
scriptloc="$BASH_SOURCE"
setupdir=$(dirname "$scriptloc")
#setupdir=$(pwd)

#change to home directory
#cd "$HOME"

# check if multilib repo is enabled
if ! pacman -Sl multilib &> /dev/null; then
    echo "Please enable the multilib repository first"
    exit 1
fi

# NOTE on unattended pacman installing
# Option 1: Will assume the default choice
#--noconfirm
# Option 2: Will always choose "yes", locale override needed to work all the time (might fail for other locales)
#yes | LC_ALL=en_US.UTF-8 pacman ...

# fix install problems
echo Updating repos and packages
sudo pacman -Syu --noconfirm
echo Installing pip
sudo pacman -S --needed --noconfirm python-pip
echo Select packages to install

cmd=(dialog --separate-output --checklist "Select Desktop environment/Window manager:" 22 76 16)
options=(100 "[WM] i3-gaps" off
         101 "[WM] sway" off)
choices=$("${cmd[@]}" "${options[@]}" 2>&1 >/dev/tty)
clear
for choice in $choices
do
    case $choice in
        100)
            echo "i3-gaps" >> "$setupdir/selectedpkgs.txt"
            ;;
        101)
            printf '%s\n' 'sway' 'swaylock' 'swayidle' >> "$setupdir/selectedpkgs.txt"
    esac
done

cmd=(dialog --separate-output --checklist "Select browsers:" 22 76 16)
options=(0 "Firefox" on    # any option can be set to default to "on"
         10 "Chromium" off
         20 "Torbrowser" off)
choices=$("${cmd[@]}" "${options[@]}" 2>&1 >/dev/tty)
clear
for choice in $choices
do
    case $choice in
        0)
            echo "firefox" >> "$setupdir/selectedpkgs.txt"
            ;;
        10)
            echo "chromium" >> "$setupdir/selectedpkgs.txt"
            ;;
        20)
            echo "torbrowser-launcher" >> "$setupdir/selectedpkgs.txt"
            ;;
    esac
done

cmd=(dialog --separate-output --checklist "Select other programs:" 22 76 16)
options=(0 "VirtManager" off    # any option can be set to default to "on"
         1 "VMWare Workstation" off
         10 "Steam" off
         11 "Lutris" off
         12 "Citra" off
         13 "Cemu" off
         20 "Krita" off
         21 "Gimp" off
         31 "YT-dlp" off
         32 "Megatools" off
         40 "Handbrake" off
         41 "Audacity" off
         50 "Easystroke" off
         60 "Discord" off
         61 "Element" off
         62 "Telegram" off
         70 "TestSSL" off)
choices=$("${cmd[@]}" "${options[@]}" 2>&1 >/dev/tty)
clear
for choice in $choices
do
    case $choice in
        0)
            printf '%s\n' 'qemu' 'virt-manager' 'ebtables' 'dnsmasq' >> "$setupdir/selectedpkgs.txt"
            ;;
        1)
            echo "vmware-workstation" >> "$setupdir/aurselectedpkgs.txt"
            ;;
        10)
            printf '%s\n' 'steam' 'steam-native-runtime' >> "$setupdir/selectedpkgs.txt"
            ;;
        11)
            echo "lutris" >> "$setupdir/selectedpkgs.txt"
            ;;
        12)
            echo "citra-qt-git" >> "$setupdir/aurselectedpkgs.txt"
            ;;
        13)
            echo "cemu" >> "$setupdir/aurselectedpkgs.txt"
            ;;
        20)
            echo "krita" >> "$setupdir/selectedpkgs.txt"
            ;;
        21)
            echo "gimp" >> "$setupdir/selectedpkgs.txt"
            ;;
        31)
            printf '%s\n' 'yt-dlp' 'yt-dlp-drop-in' >> "$setupdir/aurselectedpkgs.txt"
            ;;
        32)
            echo "megatools-bin" >> "$setupdir/aurselectedpkgs.txt"
            ;;
        40)
            echo "handbrake" >> "$setupdir/selectedpkgs.txt"
            ;;
        41)
            echo "audacity" >> "$setupdir/selectedpkgs.txt"
            ;;
        50)
            echo "easystroke" >> "$setupdir/aurselectedpkgs.txt"
            ;;
        60)
            echo "discord" >> "$setupdir/selectedpkgs.txt"
            #echo "discord_arch_electron" >> "$setupdir/aurselectedpkgs.txt"
            ;;
        61)
            echo "element-desktop" >> "$setupdir/selectedpkgs.txt"
            ;;
        62)
            echo "telegram-desktop" >> "$setupdir/selectedpkgs.txt"
            ;;
        70)
            echo "testssl.sh" >> "$setupdir/selectedpkgs.txt"
            ;;
    esac
done

in_acpufreq=0

cmd=(dialog --separate-output --checklist "Performance and Battery life" 22 76 16)
options=(0 "auto-cpufreq" off
         1 "corectrl" off)
choices=$("${cmd[@]}" "${options[@]}" 2>&1 >/dev/tty)
clear
for choice in $choices
do
    case $choice in
        0)
            in_acpufreq=1
            echo "auto-cpufreq-git" >> "$setupdir/aurselectedpkgs.txt"
            # TODO Handle rest of installation
            ;;
        1)
            echo "corectrl" >> "$setupdir/aurselectedpkgs.txt"
            ;;
    esac
done

in_doomemacs=0
in_podman=0

cmd=(dialog --separate-output --checklist "Devtools" 22 76 16)
options=(0 "doom-emacs" off
         1 "vscodium" off
         10 "Podman" off)
choices=$("${cmd[@]}" "${options[@]}" 2>&1 >/dev/tty)
clear
for choice in $choices
do
    case $choice in
        0)
            in_doomemacs=1
            # TODO sort pacman and AUR packages
            # pychecker not in AUR anymore
            printf '%s\n' 'git' 'emacs' 'ripgrep' 'fd' 'pandoc' 'shellcheck' 'python-pipenv' 'python-isort' 'python-pytest' 'python-rednose' 'pychecker' 'texlive-core' 'pyright' >> "$setupdir/aurselectedpkgs.txt"
            # TODO handle rest of installation
            ;;
        1)
            echo "vscodium-bin" >> "$setupdir/aurselectedpkgs.txt"
            ;;
        10)
            in_podman=1
            ;;
    esac
done

cmd=(dialog --separate-output --checklist "School and work communication" 22 76 16)
options=(0 "Teams" off
         1 "Slack" off
         10 "OneNote" off)
choices=$("${cmd[@]}" "${options[@]}" 2>&1 >/dev/tty)
clear
for choice in $choices
do
    case $choice in
        0)
            echo "teams" >> "$setupdir/aurselectedpkgs.txt"
            ;;
        1)
            #echo "slack-desktop" >> "$setupdir/aurselectedpkgs.txt"
            echo "slack-electron" >> "$setupdir/aurselectedpkgs.txt"
            ;;
        10)
            echo "p3x-onenote" >> "$setupdir/aurselectedpkgs.txt"
            ;;
    esac
done

cmd=(dialog --separate-output --checklist "Report installed packages?" 22 76 16)
options=(0 "pkgstats" off)
choices=$("${cmd[@]}" "${options[@]}" 2>&1 >/dev/tty)
clear
for choice in $choices
do
    case $choice in
        0)
            echo "pkgstats" >> "$setupdir/selectedpkgs.txt"
            ;;
    esac
done

: '
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
'

#uninstalling unused packages
echo Uninstalling unused packages
# || true to pass set -e (error when encountering packages not installed)
sudo pacman -Rns --noconfirm - < "$setupdir/packages/uninstall.txt" 2>/dev/null || true
echo Uninstalled unused packages

#pacman programs
echo Installing default pacman programs
sudo pacman -S --needed - < "$setupdir/packages/officialpkgs.txt" 2>/dev/null
# TODO for jack, use pipewire-jack (2)
# TODO for pipewire-session-manager, use wireplumber (2)
# TODO for phonon-qt5-backend, use phonon-qt5-gstreamer (1)
echo Installed official programs

# pip
#echo Installing python programs
# AUR package exists
#pip install --user autotrash
#echo Installed python programs

: '
# REVIEW Patched neofetch version to remove Color codes
git clone https://github.com/RealStickman/neofetch
cd neofetch
sudo make install
cd ..
rm -rf neofetch
'

# install paru-bin if not already present
if [[ ! $(pacman -Q | grep paru-bin) ]]; then
    echo "Installing paru-bin"
    git clone https://aur.archlinux.org/paru-bin.git
    cd paru-bin
    makepkg -si
    cd ..
fi

# audio
echo Installing audio programs
paru -S --needed --noconfirm - < "$setupdir/packages/audiopkgs.txt" 2>/dev/null
echo Installed audio programs

#AUR
echo Installing default AUR programs
paru -S --needed - < "$setupdir/packages/aurpkgs.txt" 2>/dev/null
# TODO for btrfsmaintenance, use btrfsmaintenance (1)
# TODO for jellyfin-media-player, use jellyfin-media-player (1)
# TODO for java-environment, use jdk-openjdk (1)
# TODO for cargo, use rust (1)
# TODO for ttf-iosevka, use ttf-iosevka (1)
# TODO for ttf-ms-fonts, use ttf-ms-fonts (1)
# TODO for ttf-vista-fonts, use ttf-vista-fonts (1)
# TODO for wps-office, use wps-office (1)
# TODO for ffmpeg-normalize, use ffmpeg-normalize (1)
# TODO for nohang, use nohang (1)
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

# install selected packages
echo Installing from official repository
# NOTE || true to continue if no packages have been selected
sudo pacman -S --needed - < "$setupdir/selectedpkgs.txt" || true

# install selected aur packages
echo Installing from AUR
# NOTE || true to continue if no packages have been selected
paru -S --needed - < "$setupdir/aurselectedpkgs.txt" || true

#performance and battery life
if [ $in_acpufreq -eq 1 ]; then
    echo "Installing auto-cpufreq"
    paru -S --needed auto-cpufreq-git
    sudo auto-cpufreq --install
    sudo systemctl start auto-cpufreq
    sudo systemctl enable auto-cpufreq
fi

#devtools
if [ $in_doomemacs -eq 1 ]; then
    echo "Installing doom-emacs"
    paru -S --needed git emacs ripgrep fd pandoc shellcheck python-pipenv python-isort python-pytest python-rednose pychecker texlive-core powershell-bin
    pip install grip
    npm i bash-language-server
    git clone --depth 1 https://github.com/hlissner/doom-emacs ~/.emacs.d
    ~/.emacs.d/bin/doom install
    export PATH="$PATH":$HOME/.emacs.d/bin
fi

if [ $in_podman -eq 1 ]; then
    echo "Installing podman"
    sudo pacman -S --needed podman podman-dnsname fuse-overlayfs
    sudo touch /etc/subuid /etc/subgid
    sudo usermod --add-subuids 100000-165536 --add-subgids 100000-165536 "$USER"
    sudo groupadd -f podman
    sudo usermod -aG podman "$USER"
fi

: '
# other system configs
# arco pc
if [ $in_arco_pc -eq 1 ]; then
    echo "Installing arco pc packages"
    paru -S --needed - < "$setupdir/packages/lupusregina-packages.txt"
fi

# arco hp
if [ $in_arco_hp -eq 1 ]; then
    echo "Installing arch hp packages"
    paru -S --needed - < "$setupdir/packages/arch-hp-packages.txt"
fi
'

##############################
#####   Configuration    #####
##############################
echo Configuring packages

#change shell
chsh -s /usr/bin/fish "$USER"

#enable vnstat
sudo systemctl enable --now vnstat

# setup autotrash
# NOTE without this directory autotrash.service fails to run
mkdir -p "$HOME/.local/share/Trash/info"
autotrash -d 5 --install
# NOTE fix script exiting after this for some reason
systemctl --user enable autotrash.timer || true

# enable lockscreen for systemd
#sudo systemctl enable betterlockscreen@$USER

# enable firewall
echo "Enabling Firewall"
sudo systemctl enable --now firewalld
sudo firewall-cmd --zone=public --permanent --remove-service=ssh

# enable lightdm
sudo systemctl enable lightdm

# regenerate locale
# Fixes rofi not launching
#sudo locale-gen

# update fonts cache
fc-cache -f

# download grub theme
#git clone https://github.com/xenlism/Grub-themes.git
#cd "Grub-themes/xenlism-grub-arch-1080p/"
#sudo bash install.sh
# go back
#cd ../../

#Changes to home folder automatically now, no need to be extra careful anymore.
# TODO make config script independent of download location
cd "$HOME"
git clone https://gitlab.com/RealStickman-arch/config
echo Finished downloading config



#cleanup
rm -rf "$setupdir"
echo Removed setup files

#downloading config
echo Setting config
bash ~/config/install.sh

# Download git repos
bash ~/config/scripts/sc-git-pull

if [[ $(pacman -Q pkgstats 2>/dev/null > /dev/null) ]]; then
    sudo systemctl enable --now pkgstats.timer
fi

echo Finished everything
exit 0
