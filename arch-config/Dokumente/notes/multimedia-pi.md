# Multimedia Device

## Base
Arch base  
Install AUR helper  
`$ paru -S kitty dolphin plasma-bigscreen-git libcec mycroft-core`  

## Autologin
`# mkdir -p /etc/systemd/system/getty@tty1.service.d`

`# vim /etc/systemd/system/getty@tty1.service.d/override.conf`  
```
[Service]
ExecStart=
ExecStart=-/usr/bin/agetty --autologin (username) --noclear %I $TERM
Type=simple
```

`# systemctl enable getty@tty1`  

## Plasma Bigscreen 
Plasma Bigscreen has issues when started directly, so we're launching a normal plasma session first  
`$ dbus-run-session startplasma-wayland`  
Then we can replace that with the bigscreen session  
`$ plasmashell --replace -p org.kde.plasma.mycroft.bigscreen`  

## Launching Plasma and Bigscreen
Put this in `.bash_profile`  
```
if [[ -z $DISPLAY ]] && [[ $(tty) = /dev/tty1 ]]; then
	dbus-run-session startplasma-wayland
fi
```

Create a script that launches bigscreen  
```
#!/usr/bin/env bash

plasmashell --replace -p org.kde.plasma.mycroft.bigscreen
```
Add the script to "autostart" in the settings. Make sure executable is set  
