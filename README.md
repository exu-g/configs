Main repository location is [https://gitea.exu.li/exu/configs](https://gitea.exu.li/exu/configs)

# Configs

All my config files, scripts and other in one place.  

## ArchLinux

First time installation:  

```sh
pacman -Syu
pacman -S git ansible just
cd $(mktemp -d)
git clone https://gitea.exu.li/exu/configs.git
cd configs
just setup
```

### Config updates

```sh
just config
```

### Package installation

``` sh
just packages
```

## Other

- [music-normalize](./music-normalize)
