Main repository location is [https://gitea.exu.li/exu/configs](https://gitea.exu.li/exu/configs)

# Configs

All my config files, scripts and other in one place.  

## ArchLinux

First time installation:  

```sh
pacman -Syu
pacman -S git ansible
cd $(mktemp -d)
git clone https://gitea.exu.li/exu/configs.git
cd configs
ansible-playbook setup.yml
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

## Other

- [music-normalize](./music-normalize)
