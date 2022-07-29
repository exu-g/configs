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

`$ export PATH="${PATH}:/home/exu/.local/bin"`
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
`$ repo sync`  

Repo fetches the latest version automatically, so we can use a symlink  
`$ ln -sf /var/lineageos-build/lineage/.repo/repo/repo ~/.local/bin/repo`  

## Add Wireguard patch to kernel

### Fetch source
Create the file `(SRC_DIR)/.repo/local_manifests/wireguard.xml`  
`(SRC_DIR)` is your `.../lineage/` directory  
Make sure to replace `(KERNEL_DIR)` with your device's kernel directory.  
For example `(SRC_DIR)/kernel/oneplus/msm8996`  
```
<?xml version="1.0" encoding="UTF-8"?>
<manifest>
	<remote name="zx2c4" fetch="https://git.zx2c4.com/" />
	<project remote="zx2c4" name="wireguard-linux-compat" path="kernel/wireguard-linux-compat" revision="master" sync-s="true">
		<linkfile src="src" dest="(KERNEL_DIR)/net/wireguard" />
	</project>
</manifest>

```

Run `repo sync`  

### Add kernel patch
Edit `(KERNEL_DIR)/net/Makefile`  
```
 obj-$(CONFIG_LLC)        += llc/
 obj-$(CONFIG_NET)        += ethernet/ 802/ sched/ netlink/
 obj-$(CONFIG_NETFILTER)  += netfilter/
+obj-$(CONFIG_WIREGUARD)  += wireguard/
 obj-$(CONFIG_INET)       += ipv4/
 obj-$(CONFIG_XFRM)       += xfrm/
 obj-$(CONFIG_UNIX)       += unix/
```

Edit `(KERNEL_DIR)/net/Kconfig`  
```
 if INET
 source "net/ipv4/Kconfig"
 source "net/ipv6/Kconfig"
 source "net/netlabel/Kconfig"
+source "net/wireguard/Kconfig"
```

Edit `(KERNEL_DIR)/arch/(ARCH)/configs/lineageos_(DEVICE)_defconfig`  

```
 CONFIG_L2TP=y
 CONFIG_BRIDGE=y
+CONFIG_WIREGUARD=y
```

## Download device source files
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

