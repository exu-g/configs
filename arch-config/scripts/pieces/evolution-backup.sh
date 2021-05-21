#!/usr/bin/env bash
set -euo pipefail

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

# go to home dir
cd "$HOME"

# get current date
currdate="$(date +%Y-%m-%d)"

mkdir -p "$HOME/evolution-mail-backup"
mkdir -p "$HOME/evolution-mail-backup/.config"
mkdir -p "$HOME/evolution-mail-backup/.local"

cp -r "$HOME/.config/evolution/" "$HOME/evolution-mail-backup/.config/"
cp -r "$HOME/.local/share/evolution/" "$HOME/evolution-mail-backup/.local/"

tar -cv -I"zstd -19 -T0" -f evolution-mail-backup-${currdate}.tar.zst evolution-mail-backup/

rm -rf "$HOME/evolution-mail-backup"

echo '$pass' | gpg -c --batch --yes --passphrase-fd 0 evolution-mail-backup-${currdate}.tar.zst

rm evolution-mail-backup-${currdate}.tar.zst

mv evolution-mail-backup-${currdate}.tar.zst.gpg "$HOME/Nextcloud/backups/"
