# Build LineageOS
https://wiki.lineageos.org/devices/oneplus3/build
https://dzx.fr/blog/how-to-compile-the-wireguard-kernel-module-for-lineageos/

## Preparing environment
I'll be using a container to keep my main system clean  

Adapted from [How to build LineageOS inside a container](https://dzx.fr/blog/how-to-build-lineageos-inside-a-container/)  

```
$ podman run -itd --name lineageos-build \
    -v /mnt/storage/lineageos-build:/var/lineageos-build \
    -v /home/marc/lineageos-cache:/var/lineageos-cache \
    docker.io/ubuntu:jammy-20220531
```

Enter the newly created container  
`$ podman exec -it lineageos-build bash`  

Install the necessary packages  
`# apt update`  
`# apt install bc bison build-essential ccache curl flex g++-multilib gcc-multilib git gnupg gperf imagemagick lib32ncurses5-dev lib32readline-dev lib32z1-dev liblz4-tool libncurses5 libncurses5-dev libsdl1.2-dev libssl-dev libxml2 libxml2-utils lzop pngcrush rsync schedtool squashfs-tools xsltproc zip zlib1g-dev python-is-python3 vim`  

Add an unpriviledged user for building  
Make sure it can access the lineageos folders mounted  
`# adduser --disabled-password (user)`  
`# chown (user):(user) -R /var/lineageos-*`  
`# su exu`  

Set cache and export to bashrc  
Create the file `~/.config/ccache/ccache.conf`  
```
max_size = 30G
cache_dir = /var/lineageos-cache
```

`$ echo 'export USE_CCACHE=1' >> ~/.bashrc`  

### Install repo tool
```
$ mkdir -p ~/.local/bin/
$ source ~/.profile
```

```
$ curl https://storage.googleapis.com/git-repo-downloads/repo > ~/.local/bin/repo
$ chmod a+x ~/.local/bin/repo
```

```
$ git config --global user.email mrc@frm01.net
$ git config --global user.name RealStickman
```

### Get source lineage code
```
$ mkdir -p /var/lineageos-build/lineage/
$ cd /var/lineageos-build/lineage/
```

Initialize the repo  
`$ repo init -u https://github.com/LineageOS/android.git -b lineage-18.1`  

Sync repo content  
This can take a long time  
`$ repo sync --force-sync`  

Repo fetches the latest version automatically, so we can use a symlink  
`$ ln -sf /var/lineageos-build/lineage/.repo/repo/repo ~/.local/bin/repo`  

### Download device source files
Activate the build environment  
`$ . ./build/envsetup.sh`  

Finally, download device specific source files  
`$ breakfast DEVICE_CODENAME`  
Device names:  
```
oneplus3
```

If `breakfast` fails, you need to extract the proprietary blobs  
[Extract blobs from the device](https://wiki.lineageos.org/devices/oneplus3/build#extract-proprietary-blobs) or [Extract blobs from LineageOS zip files](https://wiki.lineageos.org/extracting_blobs_from_zips)  

## Start build
Full build  
`$ brunch DEVICE_CODENAME`  

Kernel only  
`$ mka bootimage`  

