#!/bin/bash

#change to home (does not show in terminal)
cd $HOME

#uninstall
sudo pacman -Rns evolution catfish geany vim keepass gnome-boxes sublime-text-dev atom adwaita-icon-theme arcolinux-i3wm-git arcolinux-tweak-tool-git arcolinux-welcome-app-git clonezilla evolution-data-server numix-circle-arc-icons-git numix-circle-icon-theme-git numix-gtk-theme-git numix-icon-theme-git oh-my-zsh-git pamac-aur qbittorrent vivaldi

#update stuff
yay -Syyu
echo Updated packages

#echo Installing missing programs
#trizen -S --needed libreoffice-fresh-de steam steam-native-runtime i3-gaps lutris virt-manager ttf-ms-fonts ttf-tahoma ttf-vista-fonts discord bettergram cpu-x polybar youtube-dl blender krita termite neofetch arandr firefox variety wget sublime-text-dev picom handbrake nutty bitwarden woeusb nohang-git pcloud-drive lightdm-webkit-theme-aether gimp stress debtap obs-studio audacity python-pip tk picard hunspell hunspell-de hyphen hyphen-de fish psensor transmission-gtk rig smartmontools thunderbird code gimp-plugin-registry

echo Installing official programs
sudo pacman -S --needed xfce4 arandr qemu libreoffice-fresh-de steam steam-native-runtime i3-gaps lutris virt-manager discord youtube-dl blender krita termite neofetch firefox wget picom handbrake gimp stress obs-studio audacity python-pip hunspell hunspell-de hyphen hyphen-de fish psensor transmission-qt smartmontools thunderbird ffmpeg jre-openjdk thunar code gtk-engine-murrine bashtop iperf3

#AUR
echo Installing AUR programs
yay -S --needed ttf-ms-fonts ttf-tahoma ttf-vista-fonts bettergram cpu-x polybar nutty bitwarden woeusb nohang-git lightdm-webkit-theme-aether-git debtap rig gimp-plugin-registry
yay -S --needed pcloud-drive

#install wine
pacman -S --needed wine-staging giflib lib32-giflib libpng lib32-libpng libldap lib32-libldap gnutls lib32-gnutls mpg123 lib32-mpg123 openal lib32-openal v4l-utils lib32-v4l-utils libpulse lib32-libpulse libgpg-error lib32-libgpg-error alsa-plugins lib32-alsa-plugins alsa-lib lib32-alsa-lib libjpeg-turbo lib32-libjpeg-turbo sqlite lib32-sqlite libxcomposite lib32-libxcomposite libxinerama lib32-libgcrypt libgcrypt lib32-libxinerama ncurses lib32-ncurses opencl-icd-loader lib32-opencl-icd-loader libxslt lib32-libxslt libva lib32-libva gtk3 lib32-gtk3 gst-plugins-base-libs lib32-gst-plugins-base-libs vulkan-icd-loader lib32-vulkan-icd-loader
echo Installed packages

#pull mangohud
git clone --recurse-submodules https://github.com/flightlessmango/MangoHud.git
./MangoHud/build.sh install
#install if nvidia drivers are used
#sudo pacman -S nvidia nvidia-utils lib32-nvidia-utils nvidia-settings vulkan-icd-loader lib32-vulkan-icd-loader

sudo pip3 install ffmpeg-normalize
sudo python3 -m pip install mutagen
sudo pip install pyglet
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