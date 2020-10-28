# Rsync

## Commands

Update Movies  
```bash
rsync -uvrP --bwlimit=4096 /mnt/1d90c4d5-21d2-4455-bb4a-814de8496744/MediaLibrary/Movies/ root@jellyfin.realstickman.net:/home/jellyfin/Movies
```

Update Shows  
```bash
rsync -uvrP --bwlimit=4096 /mnt/1d90c4d5-21d2-4455-bb4a-814de8496744/MediaLibrary/Shows/ root@jellyfin.realstickman.net:/home/jellyfin/Shows
```

Update Musik  
```bash
rsync -uvrP --bwlimit=4096 /home/marc/Musik/ root@jellyfin.realstickman.net:/home/jellyfin/Musik
```
