#!/usr/bin/env bash
set -euo pipefail

# prompt for password
echo -n "Password: "
read -s -r pass
echo

# go to home dir
cd "$HOME"

# find latest backup version
latestbackup="$(find "$HOME/Nextcloud/backups/" -name "thunderbird-backup-*\.tar.zst.gpg" | sort | tail -1)"

# decrypt backup
echo '$pass' | gpg --decrypt-file --batch --yes --passphrase-fd 0 "$latestbackup"

# name of decrypted file
latestdecrypted="${latestbackup%.gpg}"

# expand archive
tar -xvf "$latestdecrypted"

# remove unencrypted archive
rm "$latestdecrypted"

# remove current thunderbird config
rm -rf $HOME/.thunderbird/*.default-release/*

# copy configuration
cp -r $HOME/thunderbird-backup/default-release/* $HOME/.thunderbird/*.default-release/

# remove folder
rm -rf "$HOME/thunderbird-backup"
