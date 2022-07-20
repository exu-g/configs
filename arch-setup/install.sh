#!/bin/bash

set -euo pipefail

# get script directory
scriptloc=$(realpath "$BASH_SOURCE")
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
#
# excpect & send

# fix install problems
echo Updating keyring
sudo pacman -Sy --noconfirm archlinux-keyring
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
            printf '%s\n' 'sway' 'swaylock' 'swayidle' 'xorg-xwayland' >> "$setupdir/selectedpkgs.txt"
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
         13 "Minigalaxy" off
         20 "Krita" off
         21 "Gimp" off
         31 "YT-dlp" off
         32 "Megatools" off
         40 "Handbrake" off
         41 "Audacity" off
         60 "Discord" on
         61 "Element" on
         62 "Telegram" on
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
            echo "minigalaxy" >> "$setupdir/aurselectedpkgs.txt"
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
    makepkg -si --noconfirm
    cd ..
fi

# audio
echo Installing audio programs
paru -S --needed --noconfirm - < "$setupdir/packages/audiopkgs.txt" 2>/dev/null
echo Installed audio programs

#AUR
echo Installing default AUR programs
paru -S --needed --noconfirm - < "$setupdir/packages/aurpkgs.txt" 2>/dev/null
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
paru -S --needed --noconfirm - < "$setupdir/packages/theme-packages.txt"
echo Installed themes and icons

#install wine
echo Installing wine
sudo pacman -S --needed --noconfirm - < "$setupdir/packages/winepkgs.txt"
echo Installed wine

###################
#selected programs#
###################
echo Installing selected programs

# install selected packages
if [ -f "$setupdir/selectedpkgs.txt" ]; then
    echo Installing from official repository
    # NOTE || true to continue if no packages have been selected
    sudo pacman -S --needed - < "$setupdir/selectedpkgs.txt" || true
fi

# install selected aur packages
if [ -f "$setupdir/aurselectedpkgs.txt" ]; then
    echo Installing from AUR
    # NOTE || true to continue if no packages have been selected
    paru -S --needed - < "$setupdir/aurselectedpkgs.txt" || true
fi

: '
if [ $in_vmware15 -eq 1 ]; then
    echo "Installing VMWare Workstation 15"
    paru -S --needed vmware-workstation15
else
    echo "Skipping VMWare Workstation 15"
fi
'

#DEs & WMs
: '
if [ $in_xfce -eq 1 ]; then
    echo "Installing xfce"
    sudo pacman -S --needed xfce4
else
    echo "Skipping xfce"
fi
'

: '
if [ $in_i3gaps -eq 1 ]; then
    echo "Installing i3-gaps"
    sudo pacman -S --needed i3-gaps
else   
    echo "Skipping i3-gaps"
fi
'

: '
#browsers
if [ $in_firefox -eq 1 ]; then
    echo "Installing Firefox"
    sudo pacman -S --needed firefox
else
    echo "Skipping Firefox"
fi
'

: '
if [ $in_chromium -eq 1 ]; then
    echo "Installing Chromium"
    sudo pacman -S --needed chromium
else
    echo "Skipping Chromium"
fi
'

: '
if [ $in_netsurf -eq 1 ]; then
    echo "Installing Netsurf"
    sudo pacman -S --needed netsurf
else
    echo "Skipping Netsurf"
fi
'

: '
if [ $in_icecat -eq 1 ]; then
    echo "Installing Icecat"
    paru -S --needed icecat-bin
else
    echo "Skipping Icecat"
fi
'

: '
if [ $in_tor -eq 1 ]; then
    echo "Installing Tor"
    sudo pacman -S --needed torbrowser-launcher
else
    echo "Skipping Tor"
fi
'

#other programs
: '
if [ $in_virtmanager -eq 1 ]; then
    echo "Installing VirtManager"
    sudo pacman -S --needed qemu virt-manager
else
    echo "Skipping VirtManager"
fi
'

: '
if [ $in_steam -eq 1 ]; then
    echo "Installing Steam"
    sudo pacman -S --needed steam steam-native-runtime
else
    echo "Skipping Steam"
fi
'

: '
if [ $in_lutris -eq 1 ]; then
    echo "Installing Lutris"
    sudo pacman -S --needed lutris
else
    echo "Skipping Lutris"
fi
'

: '
if [ $in_blender -eq 1 ]; then
    echo "Installing Blender"
    sudo pacman -S --needed blender
else
    echo "Skipping Blender"
fi
'

: '
if [ $in_krita -eq 1 ]; then
    echo "Installing Krita"
    sudo pacman -S --needed krita
else
    echo "Skipping Krita"
fi
'

: '
if [ $in_youtubedl -eq 1 ]; then
    echo "Installing Youtube-dl"
    sudo pacman -S --needed youtube-dl
else
    echo "Skipping Youtube-dl"
fi
'

: '
if [ $in_discord -eq 1 ]; then
    echo "Installing Discord"
    #sudo pacman -S --needed discord
    paru -S discord_arch_electron
else
    echo "Skipping Discord"
fi
'

: '
if [ $in_handbrake -eq 1 ]; then
    echo "Installing Handbrake"
    sudo pacman -S --needed handbrake
else
    echo "Skipping Handbrake"
fi
'

: '
if [ $in_gimp -eq 1 ]; then
    echo "Installing Gimp"
    sudo pacman -S --needed gimp
else
    echo "Skipping Gimp"
fi
'

: '
if [ $in_audacity -eq 1 ]; then
    echo "Installing Audacity"
    sudo pacman -S --needed audacity
else
    echo "Skipping Audacity"
fi
'

: '
if [ $in_mangohud -eq 1 ]; then
    echo "Installing MangoHud"
    git clone --recurse-submodules https://github.com/flightlessmango/MangoHud.git
    ./MangoHud/build.sh install
else
    echo "Skipping MangoHud"
fi
'

: '
if [ $in_liferea -eq 1 ]; then
    echo "Installing Liferea"
    paru -S --needed liferea
else
    echo "Skipping Liferea"
fi
'

: '
if [ $in_fractal -eq 1 ]; then
    echo "Installing Fractal"
    sudo pacman -S --needed fractal
else
    echo "Skipping Fractal"
fi
'

: '
if [ $in_bettergram -eq 1 ]; then
    echo "Installing Bettergram"
    paru -S --needed bettergram
else
    echo "Skipping Bettergram"
fi
'

: '
if [ $in_waifu2x -eq 1 ]; then
    echo "Installing Waifu2x"
    paru -S --needed waifu2x-ncnn-vulkan
else
    echo "Skipping Waifu2x"
fi
'

: '
if [ $in_telegram -eq 1 ]; then
    echo "Installing Telegram"
    sudo pacman -S --needed telegram-desktop
else
    echo "Skipping Telegram"
fi
'

: '
if [ $in_element -eq 1 ]; then
    echo "Installing Element"
    sudo pacman -S --needed element-desktop
else
    echo "Skipping Element"
fi
'

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

# NOTE unsets set -e temporarily
set +e
# setup autotrash
# NOTE without this directory autotrash.service fails to run
mkdir -p "$HOME/.local/share/Trash/info"
autotrash -d 5 --install
systemctl --user enable autotrash.timer
set -e

# enable lockscreen for systemd
#sudo systemctl enable betterlockscreen@$USER

# enable firewall
echo "Enabling Firewall"
sudo systemctl enable --now firewalld
# || true because firewalld doesn't work without a reboot
sudo firewall-cmd --zone=public --permanent --remove-service=ssh || true

# enable lightdm
sudo systemctl enable lightdm

# regenerate locale
# Fixes rofi not launching
#sudo locale-gen

: '
if [[ $(pacman -Q | grep sway) ]]; then
    sudo systemctl enable --now seatd.service
    sudo gpasswd -a "$USER" seat 1>/dev/null
fi
'

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
# NOTE remove directory if it exists already and redownload
rm -rf config
git clone https://gitlab.com/RealStickman-arch/config
echo Finished downloading config



#cleanup
rm -rf "$setupdir"
echo Removed setup files

#downloading config
echo Setting config
# TODO temporary
cd config
git checkout wayland
bash ~/config/install.sh

# Download git repos
bash ~/config/scripts/sc-git-pull

if [[ $(pacman -Q pkgstats 2>/dev/null > /dev/null) ]]; then
    sudo systemctl enable --now pkgstats.timer
fi

echo Finished everything
exit 0
