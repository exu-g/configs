# Compiling everything

Okay so first you need to install asp and git by typing sudo pacman -Sy asp git .

Then you need to create the CFlags by typing gcc -### -march=native /usr/include/stdlib.h and copy the output (everything from -march=whatevermatchesyourcpu) in your /etc/makepkg.conf for which you have to be root/sudo. I usually use -O3 and add -pipe -ftree-vectorize -fomit-frame-point -fopenmp at the end. The milage with the optimizations WILL vary and if you push it too hard things will break, run slower or show unexpected behaviour and not every package benefits equally from a highly optimized code.

At last comes the script, but please keep in mind that this is very experimental and in no way as good as the Carli approach from the ArcoLinux website:

#!/bin/bash
mkdir ~/.cache/asp/sources
ASPROOT=~/.cache/asp/sources/
cd ~
rm paclist.txt
pacman -Qeq > paclist.txt
file='paclist.txt'
while read line; do
clear
echo "Building and installing $line"
cd $ASPROOT
asp export $line
cd $ASPROOT/$line
makepkg -Csirc --skippgpcheck --skipinteg --noconfirm --noprogressbar
cd ~
echo "Installation complete for package $line !"
done < $file
echo "Removing source files."
sudo rm ~/.cache/asp/sources -R
echo "All packages have been successfully updated!"
echo "Restarting System in 60 Seconds, press CTRL+C NOW if you wish to abort!"
wait 60
sudo reboot


This script needs to go to you home folder. If you name it with the .sh extension you can either start it with bash script.sh or you make a chmod a+rx script.sh and then you can start it with ./script.sh .

You will have to type in your root/sudo password every 15-30 minutes or so and if you wait for too long it will time out but for some odd reason it won't say that but rather just not accept your password anymore which I think must be some kind of Arch bug.

And compiling the whole system will take AGES, with my new laptop like 24 hours straight whilst my other one needs 2-3 times as much (Intel Core i7 3632QM with 16GB RAM!)

Also in the /etc/makepkg.conf you perhaps really want to set MAKEFLAGS="-j$(nproc)" as this will ensure that all your core will be utilized for the compilation process. Your electricity bill will thank you. Please keep in mind that it doesn't work with AUR packages and you should install every package you want to use the normal way before running the script to make sure everything will benefit from it.
