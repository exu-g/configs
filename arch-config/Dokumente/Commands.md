# Commands

## Normalize audio
```bash
ffmpeg-normalize *.<format> -v -pr -c:a <audio codec> -ext <extension>
```
Examples:
```bash
ffmpeg-normalize *.flac -v -pr -c:a flac -ext flac
ffmpeg-normalize *.m4a -v -pr -c:a libopus -ext opus
ffmpeg-normalize *.opus -v -pr -c:a libopus -ext opus
```

## ffmpeg extract cover image form audio file
```
ffmpeg -i "file.flac" "cover.jpg"
```

## ffmpeg extract images from video
```bash
ffmpeg -i "file.mpg" -r 4/1 xyz%03d.png
```

## copy lightdm configured themes
```bash
sudo cp -r /var/lib/lightdm/.local/share/webkitgtk/localstorage/ ~/ && sudo chmod -Rv 777 ~/localstorage/
```

## Single 4KiB random write process
```bash
fio --output=fio-4K-randw.txt --name=random-write --ioengine=posixaio --rw=randwrite --bs=4k --size=4g --numjobs=1 --iodepth=1 --runtime=120 --time_based --end_fsync=1
```

## 16 parallel 64KiB random write processes
```bash
fio --output=fio-64K-randw-x16.txt --name=random-write --ioengine=posixaio --rw=randwrite --bs=64k --size=256m --numjobs=16 --iodepth=16 --runtime=120 --time_based --end_fsync=1
```

## Single 1MiB random write process (16gb file)
```bash
fio --output=fio-1M-randw.txt --name=random-write --ioengine=posixaio --rw=randwrite --bs=1m --size=16g --numjobs=1 --iodepth=1 --runtime=120 --time_based --end_fsync=1
```

## Single 1MiB random write process (32gb file, 5 min)
```bash
fio --output=fio-1M-randw-32gb.txt --name=random-write --ioengine=posixaio --rw=randwrite --bs=1m --size=32g --numjobs=1 --iodepth=1 --runtime=300 --time_based --end_fsync=1
```

## Single 1MiB random write process (64gb file, 10 min)
```bash
fio --output=fio-1M-randw-64gb.txt --name=random-write --ioengine=posixaio --rw=randwrite --bs=1m --size=64g --numjobs=1 --iodepth=1 --runtime=600 --time_based --end_fsync=1
```

## smartctl test
```bash
sudo smartctl -t <short|long> <disk>
```

## smartctl status
```bash
sudo smartctl -a <disk>
```

## fake identity
```bash
rig
```

## Mangohud
In Steam: ``` mangohud %command% MANGOHUD_OUTPUT /home/marc/Dokumente/log ```
Lutris: command prefix: ``` mangohud, Environment Variables: MANGOHUD_OUTPUT | /home/marc/Dokumente/log ```

## lm_sensors realtime display
```bash
watch sensors
```

## analyze startup time
```bash
systemd-analyze plot > detail[X].svg
systemd-analyze blame > detail[X].txt
```

## add kernel patch
```bash
patch -Np1 -i *file*
```

## create mkinitcpio
```bash
sudo mkinitcpio -g /boot/initramfs-[kernel].img -k [kernel from /usr/lib/modules]
```

## depmod
```bash
depmod -a
```

## pacman remove old packages
```bash
pacman -Sc
```

## Video as background
```bash
xwinwrap -g 1920x1080 -ov -- mpv -wid WID --loop --no-audio --keepaspect=no --no-osc <file>
```

### testing
```bash
xwinwrap -g 1920x1080 -ov -- mpv -wid WID --loop --no-audio --keepaspect=no --no-osc --vo=gpu /home/marc/Bilder/Backgrounds/Animated\ Backgrounds/Dune/Dune.mp4
xwinwrap -g 1920x1080 -ov -- mpv -wid WID --loop --no-audio --keepaspect=no --no-osc --vo=vaapi /home/marc/Bilder/Backgrounds/Animated\ Backgrounds/Dune/Dune.mp4
```

## generate keys per computer, only once!
```bash
ssh-keygen
```

## allow access through ssh key
```bash
ssh-copy-id -i <file location> <user>@<ip/domain>
ssh-copy-id -i ~/.ssh/id_rsa.pub <user>@<ip/domain>
```

## Ventoy
### install
```bash
sudo bash Ventoy2Disk.sh -i -g /dev/XXX
```
### update
```bash
sudo bash Ventoy2Disk.sh -u /dev/XXX
```

## PATH Variables
```
/home/marc/.local/bin:/home/marc/.bin:/usr/local/bin:/usr/bin:/bin:/usr/local/sbin:/var/lib/flatpak/exports/bin:/usr/lib/jvm/default/bin:/usr/bin/site_perl:/usr/bin/vendor_perl:/usr/bin/core_perl
```

## export path Variables
```bash
export PATH="$PATH":<path>
```

## Dots per inch
```bash
xdpyinfo | grep -B 2 resolution
```

## Bash ffmpeg batch convert
```bash
bash <pathto>/lower-vol.sh <input ext> <output ext> <input directory> <output directory> <other options>
```
```bash
bash "/home/marc/GitProjects/ffmpeg-lower-vol/lower-vol.sh" flac flac "/home/marc/Downloads/newmusik/" "/home/marc/Downloads/newmusik/converted" "-filter:a volume=0.25"
```

## Downgrade package
```bash
downgrade <packagename>
```

## Typometer
First, extract the .zip file and then the .jar file.  
Enter the newly created folder and open a terminal at that location. (Should be `<download location>/typometer-x.x.x`)  
Enter the following line in the terminal:  
```bash
java com.pavelfatin.typometer.Application
```

*Important: Use BASH instead of FISH, as the colors in FISH confuse the program.*  

## List number of items in directory
```bash
ls -1 | wc -l
```

## List size of directory
```bash
du -sh
```

## List usage of all partitions
```bash
df -h
```

## tmpmail
Look at temporary mail  
```bash
tmpmail
```

Generate new temporary mail  
```bash
tmpmail -g
```

## waifu2x
```bash
waifu2x-ncnn-vulkan -i (input directory) -o (output directory)
```

## pacnew files
Regularly run this command to resolve pacnew files
```bash
sudo pacdiff
```

## IO Utilisation
```
iostat -dx /dev/sdX
```

## copy/create/move multiple files
```
mkdir -p test/test{1,2,3}
```
```
cp source/{file1,file2}.txt destination
```

## Force usage of AUR
```
paru -S -a (package)
```

## Pulseaudio list sinks and list supported specs for sink
```
pactl list sinks | grep -Ei 'name:|sysfs.path'
```
```
grep -P 'rates|bits' /proc/asound/card(num)/codec\#0
```

## GPG
Symetric file encryption and decryption  
```
gpg -c (file)
```
```
gpg (file).gpg
```
