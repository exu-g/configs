# Restic repos:

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
restic -r b2:arco-pc-backup:/home/marc backup --verbose "/home/marc/" --exclude-file=/home/marc/Dokumente/home-exclude.txt
```
```bash
restic -r b2:arco-pc-backup:/home/marc snapshots
```
```bash
restic -r b2:arco-pc-backup:/home/marc restore --target "/home/marc/" <snapshot>
```

### arco-pc-backup timeshift

```bash
restic -r b2:arco-pc-backup:/mnt/harddrive/timeshift/snapshots init
```
```bash
sudo -E restic -r b2:arco-pc-backup:/mnt/harddrive/timeshift/snapshots backup --verbose "/mnt/1d90c4d5-21d2-4455-bb4a-814de8496744/timeshift/snapshots/"
```
```bash
restic -r b2:arco-pc-backup:/mnt/harddrive/timeshift/snapshots snapshots
```
```bash
restic -r b2:arco-pc-backup:/mnt/harddrive/timeshift/snapshots restore --target "/mnt/1d90c4d5-21d2-4455-bb4a-814de8496744/timeshift/snapshots/" <snapshot>
```

### arco-pc-backup consoles

```bash
restic -r b2:arco-pc-backup:/mnt/harddrive/Consoles init
```
```bash
restic -r b2:arco-pc-backup:/mnt/harddrive/Consoles backup --verbose "/mnt/1d90c4d5-21d2-4455-bb4a-814de8496744/Consoles"
```
```bash
restic -r b2:arco-pc-backup:/mnt/harddrive/Consoles snapshots
```
```bash
restic -r b2:arco-pc-backup:/mnt/harddrive/Consoles restore --target "/mnt/1d90c4d5-21d2-4455-bb4a-814de8496744/Consoles" <snapshot>
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
