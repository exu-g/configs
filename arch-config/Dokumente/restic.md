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

### arco-pc-backup timeshift

There is currently a problem in go that makes this command fail. Run the following command before retrying: `export GODEBUG=asyncpreemptoff=1`  
```
restic init --repo /mnt/backups/arco-pc/timeshift
```
```
sudo -E restic -r /mnt/backups/arco-pc/timeshift backup --verbose "/mnt/1d90c4d5-21d2-4455-bb4a-814de8496744/timeshift/snapshots/"
```
```
restic -r /mnt/backups/arco-pc/timeshift snapshots
```
```
restic -r /mnt/backups/arco-pc/timeshift restore --target "/mnt/1d90c4d5-21d2-4455-bb4a-814de8496744/timeshift/snapshots/" (snapshot)
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
sudo -E restic -r b2:arco-pc-backup:/mnt/harddrive backup --verbose "/mnt/1d90c4d5-21d2-4455-bb4a-814de8496744" --exclude="/mnt/1d90c4d5-21d2-4455-bb4a-814de8496744/.Trash-1000"
```
```
restic -r b2:arco-pc-backup:/mnt/harddrive snapshots
```
```
restic -r b2:arco-pc-backup:/mnt/harddrive restore --target "/mnt/1d90c4d5-21d2-4455-bb4a-814de8496744" (snapshot)
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
