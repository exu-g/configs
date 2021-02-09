# Restic repos:

## Local backups

### arco-pc-backup home
There is currently a problem in go that makes this command fail. Run the following command before retrying: `export GODEBUG=asyncpreemptoff=1`  
```
restic init --repo /mnt/backups/arco-pc/home/marc
```
```
restic -r /mnt/backups/arco-pc/home/marc backup --verbose "/home/marc/" --exclude-file=/home/marc/GitProjects/config/Dokumente/home-exclude.txt
```
```
restic -r /mnt/backups/arco-pc/home/marc snapshots
```
```
restic -r /mnt/backups/arco-pc/home/marc restore --target "/home/marc" (snapshot)
```

## B2 backups
```bash
export B2_ACCOUNT_ID=
```
```bash
export B2_ACCOUNT_KEY=
```

### arco-pc-backup home
```bash
restic -r b2:arco-pc-backup:/home/marc init
```
```bash
restic -r b2:arco-pc-backup:/home/marc backup --verbose "/home/marc/" --exclude-file=/home/marc/GitProjects/config/Dokumente/home-exclude.txt
```
```bash
restic -r b2:arco-pc-backup:/home/marc snapshots
```
```bash
restic -r b2:arco-pc-backup:/home/marc restore --target "/home/marc/" (snapshot)
```

### arco-pc-backup 3tb toshiba
```
restic -r b2:arco-pc-backup:/mnt/harddrive init
```
```
sudo -E restic -r b2:arco-pc-backup:/mnt/harddrive backup --verbose "/mnt/storage" --exclude="/mnt/storage/.Trash-1000" --exclude="/mnt/storage/MediaLibrary/Handbrake/" --exclude="/mnt/storage/SteamLibrary" --limit-upload=2048
```
```
restic -r b2:arco-pc-backup:/mnt/harddrive snapshots
```
```
restic -r b2:arco-pc-backup:/mnt/harddrive restore --target "/mnt/storage" (snapshot)
```

### hydra-server-backup /etc/nginx
```bash
restic -r b2:hydra-server-backup:/etc/nginx init
```
```bash
restic -r b2:hydra-server-backup:/etc/nginx backup --verbose "/etc/nginx"
```
```bash
restic -r b2:hydra-server-backup:/etc/nginx snapshots 
```
```bash
restic -r b2:hydra-server-backup:/etc/nginx restore --target "/etc/nginx" <snapshot>
```

### realstickman-xyz-backup root
```bash
restic -r b2:realstickman-xyz-backup:root init
```
```bash
restic -r b2:realstickman-xyz-backup:root backup --verbose "/root"
```
```bash
restic -r b2:realstickman-xyz-backup:root snapshots 
```
```bash
restic -r b2:realstickman-xyz-backup:root restore --target "/root" <snapshot>
```

### realstickman-xyz-backup etc
```bash
restic -r b2:realstickman-xyz-backup:etc init
```
```bash
restic -r b2:realstickman-xyz-backup:etc backup --verbose "/etc"
```
```bash
restic -r b2:realstickman-xyz-backup:etc snapshots 
```
```bash
restic -r b2:realstickman-xyz-backup:etc restore --target "/etc" <snapshot>
```

### nextcloud-realstickman-backup var
```
restic -r b2:nextcloud-realstickman-backup:var init
```
```
restic -r b2:nextcloud-realstickman-backup:var backup --verbose "/var"
```
```
restic -r b2:nextcloud-realstickman-backup:var snapshots 
```
```
restic -r b2:nextcloud-realstickman-backup:var restore --target "/var" <snapshot>
```
