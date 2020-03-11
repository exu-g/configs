#!/bin/bash

#change to home (does not show in terminal)
cd $HOME

#update stuff
trizen -Syyu
echo Updated packages

echo Installing missing programs
trizen -S --needed libreoffice-fresh-de keepassxc steam steam-native-runtime i3-gaps lutris wireguard-arch wireguard-tools gnome-boxes ttf-ms-fonts ttf-tahoma ttf-vista-fonts discord bettergram cpu-x polybar youtube-dl debtap obs-studio audacity python-pip tk picard hunspell hunspell-de hyphen hyphen-de fish psensor stress transmission-gtk gimp krita blender 
trizen -S --needed xfce4 termite neofetch arandr firefox variety wget sublime-text-dev picom
#trizen -S --needed keepass

#install wine
trizen -S --needed wine-staging giflib lib32-giflib libpng lib32-libpng libldap lib32-libldap gnutls lib32-gnutls mpg123 lib32-mpg123 openal lib32-openal v4l-utils lib32-v4l-utils libpulse lib32-libpulse libgpg-error lib32-libgpg-error alsa-plugins lib32-alsa-plugins alsa-lib lib32-alsa-lib libjpeg-turbo lib32-libjpeg-turbo sqlite lib32-sqlite libxcomposite lib32-libxcomposite libxinerama lib32-libgcrypt libgcrypt lib32-libxinerama ncurses lib32-ncurses opencl-icd-loader lib32-opencl-icd-loader libxslt lib32-libxslt libva lib32-libva gtk3 lib32-gtk3 gst-plugins-base-libs lib32-gst-plugins-base-libs vulkan-icd-loader lib32-vulkan-icd-loader
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

#trizen -S ttf-dejavu ttf-liberation noto-fonts
#  sudo ln -s /etc/fonts/conf.avail/70-no-bitmaps.conf /etc/fonts/conf.d
#  sudo ln -s /etc/fonts/conf.avail/10-sub-pixel-rgb.conf /etc/fonts/conf.d
#  sudo ln -s /etc/fonts/conf.avail/11-lcdfilter-default.conf /etc/fonts/conf.d

#pcloud
#wget https://p-ams1.pcloud.com/cBZetST9hZtTO10SZZZm5zha7Z2ZZaERZkZVcA5VZAkZJFZL5ZqZlJZ5XZX0Z2JZpFZ6JZ9XZG5Z5kZg5Z1EnhkZC0y6XrVckg0fVXUvkxtywbSPBEH7/pcloud
#chmod +x ~/pcloud
#~/pcloud
#echo Finished downloading pcloud

#Changes to home folder automatically now, no need to be extra careful anymore.
#git clone https://gitlab.com/RealStickman/arcolinux-config
#cp ~/arcolinux-config/.bashrc ~/
#chmod +x ~/arcolinux-config/.config/scripts/download-arcolinux-config.sh
#echo Finished downloading config

#cleanup
rm -rf ~/arcolinux-setup
echo Removed old setup files

#downloading config
#echo Setting up config
#~/arcolinux-config/.config/scripts/download-arcolinux-config.sh