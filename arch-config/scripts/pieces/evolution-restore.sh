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

# go to home dir
cd "$HOME"

# find latest backup version
latestbackup="$(find "$HOME/Nextcloud/backups/" -name "evolution-mail-backup-*\.tar.zst.gpg" | sort | tail -1)"

# decrypt backup
echo '$pass' | gpg --decrypt-file --batch --yes --passphrase-fd 0 "$latestbackup"

# name of decrypted file
latestdecrypted="${latestbackup%.gpg}"

# expand archive
tar -xvf "$latestdecrypted"

# remove unencrypted archive
rm "$latestdecrypted"

# copy configuration
cp -r "$HOME/evolution-mail-backup/.config/" "$HOME/"
cp -r "$HOME/evolution-mail-backup/.local/" "$HOME/"

# remove folder
rm -rf "$HOME/evolution-mail-backup"
