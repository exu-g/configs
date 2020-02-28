#!/bin/bash
cd $HOME
trizen -S libreoffice-fresh-de keepass steam steam-native-runtime lutris wireguard-arch wireguard-tools gnome-boxes ttf-ms-fonts ttf-tahoma ttf-vista-fonts discord bettergram cpu-x polybar youtube-dl debtap obs-studio audacity python-pip tk pyglet picard hunspell hunspell-de hyphen hyphen-de fish psensor stress transmission-gtk

#install if nvidia drivers are used
#sudo pacman -S nvidia nvidia-utils lib32-nvidia-utils nvidia-settings vulkan-icd-loader lib32-vulkan-icd-loader

sudo pip3 install ffmpeg-normalize
sudo python3 -m pip install mutagen

#trizen -S ttf-dejavu ttf-liberation noto-fonts
#  sudo ln -s /etc/fonts/conf.avail/70-no-bitmaps.conf /etc/fonts/conf.d
#  sudo ln -s /etc/fonts/conf.avail/10-sub-pixel-rgb.conf /etc/fonts/conf.d
#  sudo ln -s /etc/fonts/conf.avail/11-lcdfilter-default.conf /etc/fonts/conf.d

#pcloud
https://www.pcloud.com/how-to-install-pcloud-drive-linux.html?download=electron-64
cp ~/Downloads/pcloud ~/
chmod +x ~/pcloud
~/pcloud

#execute this in the home folder!!
git clone https://gitlab.com/RealStickman/arcolinux-config
cp ~/arcolinux-config/.bashrc ~/
chmod +x ~/arcolinux-config/.config/scripts/download-arcolinux-config.sh
~/arcolinux-config/.config/scripts/download-arcolinux-config.sh