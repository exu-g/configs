#!/usr/bin/env bash
set -euo pipefail

: '
# give password as argument
if [ $# -eq 1 ]; then
    pass=$1
elif [ $# -eq 0 ]; then
    echo "Please provide a passphrase"
    $(exit 1); echo "$?"
else
    echo "Please only insert one argument"
    $(exit 1); echo "$?"
fi
'

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
tar -cv -I"zstd -19 -T0" -f evolution-mail-backup-${currdate}.tar.zst evolution-mail-backup/

# remove backup dir
rm -rf "$HOME/evolution-mail-backup"

# encrypt backup archive
echo '$pass' | gpg -c --batch --yes --passphrase-fd 0 evolution-mail-backup-${currdate}.tar.zst

# remove unencrypted archive
rm evolution-mail-backup-${currdate}.tar.zst

# put encrypted archive into backups folder
mv evolution-mail-backup-${currdate}.tar.zst.gpg "$HOME/Nextcloud/backups/"
