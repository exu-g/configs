#!/usr/bin/env bash

set -euo pipefail

# Collect all PIDs of background processes that should be waited for
pids=""

cat <<EOF
########################################
######### Copy New Config Root #########
########################################
EOF

#copy stuff to /etc
sudo cp -r "$tempdir/arch-config/etc" /

#copy usr stuff
sudo cp -r "$tempdir/arch-config/usr" /

echo Copied folders root

# NOTE Distro specific stuff
# TODO simplify for Arch only
distro=$(cat /etc/*-release | grep "^ID=")
if [ "$distro" == "ID=arch" ]; then
    sudo mv /etc/arch-pacman.conf /etc/pacman.conf
fi

echo Copied single files

cat <<EOF
##############################
## Per Device Settings Root ##
##############################
EOF

# lupusregina
# TODO analyse parts necessary for Wayland with Alita
if [ "$(hostname)" == "lupusregina" ]; then
    sudo cp ~/configs/arch-config/per-device/lupusregina/10-monitor.conf /etc/X11/xorg.conf.d/
    sudo cp ~/configs/arch-config/per-device/lupusregina/20-amdgpu.conf /etc/X11/xorg.conf.d/
fi

cat <<EOF
########################################
############# Services Root ############
########################################
EOF

# reload systemd scripts
systemctl daemon-reload

# set systemd services for vmware (only if installed)
if [[ $(pacman -Q | grep vmware-workstation) ]]; then
    sudo systemctl enable --now vmware-networks.service || echo "Service failed, continuing"
    sudo systemctl enable --now vmware-usbarbitrator.service || echo "Service failed, continuing"
fi

# enable fstrim timer
sudo systemctl enable fstrim.timer

# enable btrfs maintenance timers
if [[ $(pacman -Q | grep btrfsmaintenance) ]]; then
    sudo systemctl restart btrfsmaintenance-refresh.service
    sudo systemctl enable btrfs-balance.timer
    sudo systemctl enable btrfs-scrub.timer
fi

# enable systemd-timesyncd (ntp service)
sudo timedatectl set-ntp true

# enable reflector timer
sudo systemctl enable reflector.timer

# enable vnstat
sudo systemctl enable vnstat

cat <<EOF
########################################
################ Groups ################
########################################
EOF

# set systemd and group for vmware (only if installed)
if [[ $(pacman -Q | grep vmware-workstation) ]]; then
    echo "Setting up group for vmware"
    sudo groupadd -f vmware
    sudo gpasswd -a "$USER" vmware 1>/dev/null
fi

# set group for libvirt
if [[ $(pacman -Q | grep libvirt) ]]; then
    echo "Setting group for libvirt"
    sudo gpasswd -a "$USER" libvirt 1>/dev/null
fi

# set group for wireshark (only if installed)
if [[ $(pacman -Q | grep wireshark-qt) ]]; then
    echo "Setting up group for wireshark"
    sudo groupadd -f wireshark
    sudo gpasswd -a "$USER" wireshark 1>/dev/null
fi

# add group for corectrl
if [[ $(pacman -Q | grep corectrl) ]]; then
    echo "Setting up group for corectrl"
    sudo groupadd -f corectrl
    sudo gpasswd -a "$USER" corectrl 1>/dev/null
fi

# group for controlling backlight
echo "Setting group for backlight"
sudo groupadd -f video
sudo gpasswd -a "$USER" video 1>/dev/null

# group for monitoring wireguard
echo "Setting group for wireguard"
sudo groupadd -f wireguard
sudo gpasswd -a "$USER" wireguard 1>/dev/null

cat <<EOF
########################################
########### Misc Config Root ###########
########################################
EOF

# set permissions for sudoers.d to root only
sudo chown root:root -R /etc/sudoers.d/
sudo chmod 600 -R /etc/sudoers.d/

cat <<EOF
########################################
############ Reloading Root ############
########################################
EOF

# disable freedesktop notification daemon
if [[ -f "/usr/share/dbus-1/services/org.freedesktop.Notifications.service" ]]; then
    sudo mv /usr/share/dbus-1/services/org.freedesktop.Notifications.service /usr/share/dbus-1/services/org.freedesktop.Notifications.service.disabled
fi

# wait for all background jobs to finish
wait $pids && echo "Finished background jobs"