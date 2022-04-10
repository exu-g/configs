#!/usr/bin/env bash
set -euo pipefail

# prompt for password
echo -n "Password: "
read -s -r pass
echo

# prompt a second time
echo -n "Repeat Password: "
read -s -r pass2
echo

# check correctness
if [ ! "$pass" = "$pass2" ]; then
    echo "Passwords don't match!"
    exit
fi

# go to home dir
cd "$HOME"

# get current date
currdate="$(date +%Y-%m-%d)"

# create backup directory
mkdir -p "$HOME/evolution-mail-backup"
mkdir -p "$HOME/evolution-mail-backup/.config"
mkdir -p "$HOME/evolution-mail-backup/.local"

# copy stuff to backup directory
cp -r "$HOME/.config/evolution/" "$HOME/evolution-mail-backup/.config/"
cp -r "$HOME/.local/share/evolution/" "$HOME/evolution-mail-backup/.local/"

# create archive from backup
tar -c -I"zstd -19 -T0" -f evolution-mail-backup-${currdate}.tar.zst evolution-mail-backup/

# remove backup dir
rm -rf "$HOME/evolution-mail-backup"

# encrypt backup archive
echo '$pass' | gpg -c --batch --yes --passphrase-fd 0 evolution-mail-backup-${currdate}.tar.zst

# remove unencrypted archive
rm evolution-mail-backup-${currdate}.tar.zst

# put encrypted archive into backups folder
mv evolution-mail-backup-${currdate}.tar.zst.gpg "$HOME/Nextcloud/backups/"

# remove more than the last 3 backups
#find "$HOME/Nextcloud/backups/" -name "evolution-mail-backup-*\.tar.zst.gpg" | sort -r | tail -n +4
mapfile -t old_backups < <( find "$HOME/Nextcloud/backups/" -name "evolution-mail-backup-*\.tar.zst.gpg" | sort -r | tail -n +4 )

for backup in "${old_backups[@]}"; do
    echo "Removing old backup. $backup"
    rm "$backup"
done
