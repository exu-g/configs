# Rsync

## Commands

### Update Movies  
*Don't use this*  
```
rsync -uvr --progress --bwlimit=4096 /mnt/1d90c4d5-21d2-4455-bb4a-814de8496744/MediaLibrary/Movies/ root@jellyfin.realstickman.net:/home/jellyfin/Movies/
```
*Non-root user*  
```
rsync -uvr --progress --bwlimit=4096 --chmod=744 -e "ssh -i $HOME/.ssh/id_ed25519_non-root" /mnt/1d90c4d5-21d2-4455-bb4a-814de8496744/MediaLibrary/Movies/ jellyfin@jellyfin.realstickman.net:/home/jellyfin/Movies/
```

### Update Shows  
*Don't use this*  
```
rsync -uvr --progress --bwlimit=4096 /mnt/1d90c4d5-21d2-4455-bb4a-814de8496744/MediaLibrary/Shows/ root@jellyfin.realstickman.net:/home/jellyfin/Shows/
```
*Non-root user*  
```
rsync -uvr --progress --bwlimit=4096 --chmod=744 -e "ssh -i $HOME/.ssh/id_ed25519_non-root" /mnt/1d90c4d5-21d2-4455-bb4a-814de8496744/MediaLibrary/Shows/ jellyfin@jellyfin.realstickman.net:/home/jellyfin/Shows/

```

### Update Musik  
*Don't use this*  
```
rsync -uvr --progress --bwlimit=4096 /home/marc/Musik/ root@jellyfin.realstickman.net:/home/jellyfin/Musik/
```
*Non-root user*  
```
rsync -uvr --progress --bwlimit=4096 --chmod=744 -e "ssh -i $HOME/.ssh/id_ed25519_non-root" /home/marc/Musik/ jellyfin@jellyfin.realstickman.net:/home/jellyfin/Musik/
```

Update Website  
```
rsync -vr --bwlimit=4096 /home/marc/GitProjects/website/ root@realstickman.net:/var/www/website/
```
