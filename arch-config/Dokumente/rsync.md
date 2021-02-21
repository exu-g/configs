# Rsync

## Commands

### Update Movies
```
rsync -uvr --progress --bwlimit=4096 --chmod=744 -e "ssh -i $HOME/.ssh/id_ed25519_non-root" /mnt/storage/MediaLibrary/Movies/ jellyfin@hydra.realstickman.net:/home/jellyfin/Movies/
```

### Update Shows
```
rsync -uvr --progress --bwlimit=4096 --chmod=744 -e "ssh -i $HOME/.ssh/id_ed25519_non-root" /mnt/storage/MediaLibrary/Shows/ jellyfin@hydra.realstickman.net:/home/jellyfin/Shows/

```

### Update Musik
```
rsync -uvrL --progress --bwlimit=4096 --chmod=744 -e "ssh -i $HOME/.ssh/id_ed25519_non-root" /home/marc/Musik/ jellyfin@hydra.realstickman.net:/home/jellyfin/Musik/
```

### Update Website
```
rsync -vrz --bwlimit=4096 /home/marc/GitProjects/website/ root@hydra.realstickman.net:/var/www/website/
```
