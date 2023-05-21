#!/bin/bash

# TODO make this work
# NOTE ignore errors from missing "||". Try getting the line below to work
#set -euo pipefail

# function to keep sudo from timing out
function func_dont_timeout {
    while true; do
        sudo -v
        sleep 60
    done
}

# check if user is root
if [ "$EUID" -ne 0 ]; then
    sudo -v
fi

# keep sudo active in background
func_dont_timeout &

# get current directory
setupdir=$(pwd)

#change to home (does not show in terminal)
cd "$HOME"

# check if multilib repo is enabled
if ! pacman -Sl multilib &>/dev/null; then
    echo "Please enable the multilib repository first"
    exit 1
fi

# NOTE on unattended pacman installing
# Option 1: Will assume the default choice
#--noconfirm
# Option 2: Will always choose "yes", locale override needed to work all the time (might fail for other locales)
#yes | LC_ALL=en_US.UTF-8 pacman ...
#
# excpect & send

# fix install problems
echo Updating keyring
sudo pacman -Sy --noconfirm archlinux-keyring
echo Updating repos and packages
sudo pacman -Syu
echo Select packages to install

cmd=(dialog --separate-output --checklist "Select Desktop environment/Window manager:" 22 76 16)
options=(0 "[DE] xfce4" off # any option can be set to default to "on"
    100 "[WM] i3-gaps" off)
choices=$("${cmd[@]}" "${options[@]}" 2>&1 >/dev/tty)
clear
for choice in $choices; do
    case $choice in
        0)
            echo "xfce4" >>"$setupdir/selectedpkgs.txt"
            ;;
        100)
            echo "i3-gaps" >>"$setupdir/selectedpkgs.txt"
            ;;
    esac
done

cmd=(dialog --separate-output --checklist "Select browsers:" 22 76 16)
options=(0 "Firefox" on # any option can be set to default to "on"
    10 "Chromium" off
    20 "Torbrowser" off)
choices=$("${cmd[@]}" "${options[@]}" 2>&1 >/dev/tty)
clear
for choice in $choices; do
    case $choice in
        0)
            echo "firefox" >>"$setupdir/selectedpkgs.txt"
            ;;
        10)
            echo "chromium" >>"$setupdir/selectedpkgs.txt"
            ;;
        20)
            echo "torbrowser-launcher" >>"$setupdir/selectedpkgs.txt"
            ;;
    esac
done

cmd=(dialog --separate-output --checklist "Select other programs:" 22 76 16)
options=(0 "VirtManager" off # any option can be set to default to "on"
    1 "VMWare Workstation" off
    10 "Steam" off
    11 "Lutris" off
    12 "Citra" off
    13 "Minigalaxy" off
    20 "Krita" off
    21 "Gimp" off
    31 "YT-dlp" on
    32 "Megatools" off
    40 "Handbrake" off
    41 "Audacity" off
    42 "k3b" off
    60 "Discord" on
    61 "Element" on
    62 "Telegram" on
    70 "TestSSL" off
    80 "Onedriver" off)
choices=$("${cmd[@]}" "${options[@]}" 2>&1 >/dev/tty)
clear
for choice in $choices; do
    case $choice in
        0)
            printf '%s\n' 'qemu' 'virt-manager' 'ebtables' 'dnsmasq' >>"$setupdir/selectedpkgs.txt"
            ;;
        1)
            echo "vmware-workstation" >>"$setupdir/aurselectedpkgs.txt"
            ;;
        10)
            printf '%s\n' 'steam' 'steam-native-runtime' >>"$setupdir/selectedpkgs.txt"
            ;;
        11)
            echo "lutris" >>"$setupdir/selectedpkgs.txt"
            ;;
        12)
            echo "citra-qt-git" >>"$setupdir/aurselectedpkgs.txt"
            ;;
        13)
            echo "minigalaxy" >>"$setupdir/aurselectedpkgs.txt"
            ;;
        20)
            echo "krita" >>"$setupdir/selectedpkgs.txt"
            ;;
        21)
            echo "gimp" >>"$setupdir/selectedpkgs.txt"
            ;;
        31)
            printf '%s\n' 'yt-dlp' 'yt-dlp-drop-in' >>"$setupdir/aurselectedpkgs.txt"
            ;;
        32)
            echo "megatools-bin" >>"$setupdir/aurselectedpkgs.txt"
            ;;
        40)
            echo "handbrake" >>"$setupdir/selectedpkgs.txt"
            ;;
        41)
            echo "audacity" >>"$setupdir/selectedpkgs.txt"
            ;;
        42)
            printf '%s\n' 'k3b' 'cdparanoia' 'cdrdao' 'cdrtools' 'dvd+rw-tools' 'emovix' 'transcode' 'vcdimager' >>"$setupdir/selectedpkgs.txt"
            ;;
        60)
            echo "discord" >>"$setupdir/selectedpkgs.txt"
            ;;
        61)
            echo "element-desktop" >>"$setupdir/selectedpkgs.txt"
            ;;
        62)
            echo "telegram-desktop" >>"$setupdir/selectedpkgs.txt"
            ;;
        70)
            echo "testssl.sh" >>"$setupdir/selectedpkgs.txt"
            ;;
        80)
            echo "onedriver" >>"$setupdir/aurselectedpkgs.txt"
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
for choice in $choices; do
    case $choice in
        0)
            in_doomemacs=1
            # TODO sort pacman and AUR packages
            # pychecker not in AUR anymore
            printf '%s\n' 'git' 'emacs' 'ripgrep' 'fd' 'pandoc' 'shellcheck' 'python-pipenv' 'python-isort' 'python-pytest' 'python-rednose' 'pychecker' 'texlive-core' 'pyright' 'python-grip' 'prettier' 'shfmt' >>"$setupdir/aurselectedpkgs.txt"
            # TODO handle rest of installation
            ;;
        1)
            echo "vscodium-bin" >>"$setupdir/aurselectedpkgs.txt"
            ;;
        10)
            in_podman=1
            ;;
    esac
done

cmd=(dialog --separate-output --checklist "School and work communication" 22 76 16)
options=(0 "Teams" off
    10 "OneNote" off)
choices=$("${cmd[@]}" "${options[@]}" 2>&1 >/dev/tty)
clear
for choice in $choices; do
    case $choice in
        0)
            echo "teams" >>"$setupdir/aurselectedpkgs.txt"
            ;;
        10)
            echo "p3x-onenote" >>"$setupdir/aurselectedpkgs.txt"
            ;;
    esac
done

cmd=(dialog --separate-output --checklist "Report installed packages?" 22 76 16)
options=(0 "pkgstats" off)
choices=$("${cmd[@]}" "${options[@]}" 2>&1 >/dev/tty)
clear
for choice in $choices; do
    case $choice in
        0)
            echo "pkgstats" >>"$setupdir/selectedpkgs.txt"
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
for choice in $choices; do
    case $choice in
        1)
            in_arco_pc=1
            ;;
        2)
            in_arco_hp=1
            ;;
    esac
done

rm "$setupdir/notfoundpackages.txt"

#uninstalling unused packages
echo Uninstalling unused packages
#sudo pacman -Rns - <"$setupdir/packages/uninstall.txt"
while read package; do
    sudo pacman -Rns "$package"
done <"$setupdir/packages/uninstall.txt"
echo Uninstalled unused packages

#pacman programs
echo Installing default pacman programs
#sudo pacman -S --needed - <"$setupdir/packages/officialpkgs.txt"
while read package; do
    sudo pacman -S --needed "$package" || echo "$package" >>"$setupdir/notfoundpackages.txt"
    exit
done <"$setupdir/packages/officialpkgs.txt"
echo Installed official programs

#install wine
echo Installing wine
#sudo pacman -S --needed - <"$setupdir/packages/winepkgs.txt"
while read package; do
    sudo pacman -S --needed "$package" || echo "$package" >>"$setupdir/notfoundpackages.txt"
done <"$setupdir/packages/winepkgs.txt"
echo Installed wine

# install paru-bin with yay, or download paru from github
if [[ $(pacman -Q | grep yay) ]] && [[ ! $(pacman -Q | grep paru) ]]; then
    echo "Installing paru"
    yay -S paru-bin
elif [[ ! $(pacman -Q | grep yay) ]] && [[ ! $(pacman -Q | grep paru) ]]; then
    echo "Installing paru from git"
    git clone https://aur.archlinux.org/paru-bin.git
    cd paru-bin
    makepkg -si
    cd ..
fi

# AUR
echo Installing default AUR programs
paru -S --needed - <"$setupdir/packages/aurpkgs.txt"
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
paru -S --needed - <"$setupdir/packages/theme-packages.txt"
echo Installed themes and icons

###################
#selected programs#
###################
echo Installing selected programs

# install selected packages
if [ -f "$setupdir/selectedpkgs.txt" ]; then
    echo Installing from official repository
    # NOTE || true to continue if no packages have been selected
    sudo pacman -S --needed - <"$setupdir/selectedpkgs.txt" || true
fi

# install selected aur packages
if [ -f "$setupdir/aurselectedpkgs.txt" ]; then
    echo Installing from AUR
    # NOTE || true to continue if no packages have been selected
    paru -S --needed - <"$setupdir/aurselectedpkgs.txt" || true
fi

#devtools
if [ $in_doomemacs -eq 1 ]; then
    echo "Installing doom-emacs"
    paru -S --needed git emacs ripgrep fd pandoc shellcheck python-pipenv python-isort python-pytest python-rednose pychecker texlive-core powershell-bin python-black
    pip install grip
    npm i bash-language-server
    git clone --depth 1 https://github.com/hlissner/doom-emacs ~/.emacs.d
    ~/.emacs.d/bin/doom install
    export PATH="$PATH":$HOME/.emacs.d/bin
else
    echo "Skipping doom-emacs"
fi

if [ $in_podman -eq 1 ]; then
    echo "Installing podman"
    sudo pacman -S --needed podman podman-dnsname fuse-overlayfs buildah
    sudo touch /etc/subuid /etc/subgid
    sudo usermod --add-subuids 100000-165536 --add-subgids 100000-165536 "$USER"
    sudo groupadd -f podman
    sudo usermod -aG podman "$USER"
else
    echo "Skipping podman"
fi

# other system configs
# arco pc
if [ $in_arco_pc -eq 1 ]; then
    echo "Installing arco pc packages"
    paru -S --needed - <"$setupdir/packages/lupusregina-packages.txt"
fi

# arco hp
if [ $in_arco_hp -eq 1 ]; then
    echo "Installing arch hp packages"
    paru -S --needed - <"$setupdir/packages/arch-hp-packages.txt"
fi

# install nix
#curl -sSf -L https://install.determinate.systems/nix | sh -s -- install

##############################
#####   Configuration    #####
##############################

#change shell
chsh -s /usr/bin/fish "$USER"

#enable vnstat
sudo systemctl enable vnstat
sudo systemctl start vnstat

# setup autotrash
autotrash -td 5 --install
systemctl --user start autotrash
systemctl --user enable autotrash.timer

# enable lockscreen for systemd
sudo systemctl enable betterlockscreen@$USER

# enable firewall
echo "Enabling Firewall"
sudo systemctl enable --now firewalld
sudo firewall-cmd --zone=public --permanent --remove-service=ssh

# enable lightdm
sudo systemctl enable lightdm

# regenerate locale
# Fixes rofi not launching
sudo locale-gen

# update fonts cache
fc-cache -f

# download grub theme
git clone https://github.com/xenlism/Grub-themes.git
cd "Grub-themes/xenlism-grub-arch-1080p/"
sudo bash install.sh
# go back
cd ../../

echo Setting config
bash ~/configs/arch-config/install.sh

if [[ $(pacman -Q pkgstats 2>/dev/null >/dev/null) ]]; then
    pkgstats
fi

echo Finished everything
exit 0
