# Restic repos:

## Local backups

### Generalised version

#### Initialise repository
`restic -r (storage path) init`  

#### Create backup
`restic -r (storage path) backup --verbose "(backup path)" --exclude-file=(exclude file)`  

#### Show snapshots
`restic -r (storage path) snapshots`  

#### Restore snapshot
`restic -r (storage path) restore --target "(backup path)" (snapshot)`  

### lupusregina-backup home
There is currently a problem in go that makes this command fail. Run the following command before retrying: `export GODEBUG=asyncpreemptoff=1`  
Storage path: `/mnt/backups/arco-pc/home/marc`  
Backup path: `/home/marc`  
Exclude file: `/home/marc/GitProjects/config/Dokumente/home-exclude.txt`  

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
`-n` for dry run  
`--prune=true` also run prune  

Only keep last X snapshots.  
Does not remove data, just links  
`restic -r b2:(bucket):(path) forget -l (X)`  

Remove snapshots without certain tag
`restic -r b2:(bucket):(path) forget --keep-tag=(tag)`  

Clean up unreferenced data.  
`restic -r b2:(bucket):(path) prune`  

### lupusregina-backup home
Bucket: `arco-pc-backup`  
Path: `/home/marc`  
Exclude file: `/home/marc/GitProjects/config/Dokumente/home-exclude.txt`  

### lupusregina-backup 3tb toshiba
Bucket: `arco-pc-backup`  
Path: `/mnt/harddrive`  
Exclude file: `/home/marc/GitProjects/config/Dokumente/storage-exclude.txt`  

### albedo-server-backup var/www
Bucket: `hydra-server-backup`  
Path: `/var/www`  

### albedo-server-backup etc
Bucket: `hydra-server-backup`  
Path: `/etc`  

### aura-server-backup etc
Bucket: `aura-server-backup`  
Path: `/etc`  
test
