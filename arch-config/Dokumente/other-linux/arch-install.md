# Arch Installation

## Keyboard layout
```bash
loadkeys de_CH-latin1
```

## Check UEFI mode
If the following command works, the system is booted in EFI.  
```bash
ls /sys/firmware/efi/efivars
```

## Verify internet connection
```bash
ping realstickman.net
```

## Update system clock
```bash
timedatectl set-ntp true
```

## Creating partitions
```bash
cfdisk
```

## Format partitions
Fat 32:  
```bash
mkfs.fat -F32 /dev/(partition)
```

Ext4:  
```bash
mkfs.ext4 /dev/(partition)
```

btrfs:  
```bash
mkfs.btrfs /dev/(partition)
```

## Mounting partitions
Generally partitions have to be mounted where you will later use them in your system.  

Root: /mnt
EFI: /mnt/boot or /mnt/efi
Home: /mnt/home

## Creating swapfile
*Not applicable to btrfs*  
```bash
dd if=/dev/zero of=/mnt/swapfile bs=1M count=(size) status=progress
```

*Swapfile in btrfs*  
```bash
truncate -s 0 /mnt/swapfile
```

```bash
chattr +C /mnt/swapfile
```

```bash
btrfs property set /mnt/swapfile compression none
```

```bash
fallocate -l 4096M /mnt/swapfile
```

*Initialising swapfile*  
```bash
chmod 600 /mnt/swapfile
```

```bash
mkswap /mnt/swapfile
```

```bash
swapon /mnt/swapfile
```

## Essential packages
Some things like the userspace utilities for file management will vary.  
See [file systems](https://wiki.archlinux.org/index.php/File_systems#Types_of_file_systems)  
```bash
pacstrap /mnt base linux linux-firmware vim git openssh networkmanager network-manager-applet dialog base-devel linux-headers 
```

### Packages needed for file systems
Fat32:  
```bash
dosfstools mtools
```

Ext4:  
```bash
e2fsprogs
```

btrfs:  
```bash
btrfs-progs
```

## Generate fstab
```bash
genfstab -U /mnt >> /mnt/etc/fstab
```
IMPORTANT: Make sure the fstab file has everything included  

## Chroot into the system
`arch-chroot /mnt`  

## Set timezone
`ln -sf /usr/share/zoneinfo/Europe/Zurich /etc/localtime`  

## Set hardware clock
`hwclock --systohc`  

## Set locale
`vim /etc/locale.gen`  
Uncomment the locales that should be generated.  
Make sure to use a UTF-8 entry.  

`locale-gen`  

Edit `/etc/locale.conf` and set `LANG=(locale)`.  
`LANG=de_CH.UTF-8`  

## Set keymap permanently
`vim /etc/vconsole.conf`  
`KEYMAP=de_CH-latin1`  

## Set hostname
Edit `/etc/hostname`  
`(hostname)`  

Edit `/etc/hosts`  
```
127.0.0.1	localhost
::1		localhost
127.0.1.1	(hostname).localdomain	(hostname)
```

## Change root password
`passwd`  

## Bootloader installation

### GRUB
```bash
pacman -S grub efibootmgr 
```

```bash
grub-install --target=x86_64-efi --efi-directory=(efi partition mountpoint) --bootloader-id=GRUB
```

```bash
grub-mkconfig -o /boot/grub/grub.cfg
```

### systemd-boot

### rEFInd

## Networking
`systemctl enable NetworkManager`  

## Add user
`useradd -mG wheel (user)`  

Set password  
`passwd (user)`  

### Enable sudo
`visudo`  
Uncomment `%wheel ALL=(ALL) ALL`  

## Finishing installation
`exit`  
`poweroff`  
Remove the installation cd  

## Install AUR helper

### yay
```bash
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si
```


