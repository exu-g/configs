Main repository location is [https://gitea.exu.li/exu/configs](https://gitea.exu.li/exu/configs)

# Configs

All my config files, scripts and other in one place.  
Mostly focused on ArchLinux, although there is also a NixOS configuration and independent Python programs.

## ArchLinux

- [arch-config](./arch-config)
- [arch-setup](./arch-setup)

### First time installation

Enable the `multilib` repository in `/etc/pacman.conf`

```sh
git clone https://gitea.exu.li/realstickman/configs.git
cd configs/arch-setup
./install.sh
```

### Config updates

Either use the included alias

```sh
upconf
```

or run the script directly.

```sh
~/scripts/arch-config.sh
```

## NixOS

- [nixos-config](./nixos-config)

## Other

- [easyffmpeg](./easyffmpeg)
- [music-normalize](./music-normalize)
