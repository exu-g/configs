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

### Generalised version

#### Initialise repository
`restic -r b2:(bucket):(path) init`  

#### Create backup
`restic -r b2:(bucket):(path) backup --verbose "(path)" --exclude-file=(exclude file)`

#### Show snapshots
`restic -r b2:(bucket):(path) snapshots`  

#### Restore snapshot
`restic -r b2:(bucket):(path) restore --target "(path)" (snapshot)`  

#### Remove Snapshots
Only keep last X snapshots. Use "-n" to do a dry run  
Does not remove data, just links  
`restic -r b2:(bucket):(path) forget -l (X)`  

Clean up unreferenced data. "-n" for dry run  
`restic -r b2:(bucket):(path) prune`  

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
restic -r b2:arco-pc-backup:/mnt/harddrive backup --verbose "/mnt/storage" --exclude-file=/home/marc/GitProjects/config/Dokumente/storage-exclude.txt --limit-upload=2048
```
```
restic -r b2:arco-pc-backup:/mnt/harddrive snapshots
```
```
restic -r b2:arco-pc-backup:/mnt/harddrive restore --target "/mnt/storage" (snapshot)
```

### hydra-server-backup var/www
```
restic -r b2:hydra-server-backup:var/www init
```
```
restic -r b2:hydra-server-backup:var/www backup --verbose "/var/www"
```
```
restic -r b2:hydra-server-backup:var/www snapshots 
```
```
restic -r b2:hydra-server-backup:var/www restore --target "/var/www" <snapshot>
```

### hydra-server-backup etc
```
restic -r b2:hydra-server-backup:etc init
```
```
restic -r b2:hydra-server-backup:etc backup --verbose "/etc"
```
```
restic -r b2:hydra-server-backup:etc snapshots 
```
```
restic -r b2:hydra-server-backup:etc restore --target "/etc" <snapshot>
```
