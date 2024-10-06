#!/usr/bin/env sh
set -euo pipefail

# exit thunderbird
fn_killbird() {
    # kill thunderbird
    pkill thunderbird
    # wait for a bit before checking again
    sleep 5s
}

# check if thunderbird is running
fn_checkbird() {
    # check for thunderbird using pgrep
    while [ $(pgrep thunderbird) ]; do
        # get user input whether to shut down or exit
        # default is exiting
        read -p "Thunderbird is running. Do you want to shut it down now? [yN]: " yn
        case $yn in
            # handle closing thunderbird
            [Yy]*)
                fn_killbird
                break
                ;;
            # explicit no, exit
            [Nn]*)
                echo "Please close Thunderbird and try again."
                exit
                ;;
            # implicit no, exit
            *)
                echo "Please close Thunderbird and try again."
                exit
                ;;
        esac
    done
}

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

# check if thunderbird is running
fn_checkbird

# go to home dir
cd "$HOME"

# get current date
currdate="$(date +%Y-%m-%d)"

# create backup directory
mkdir -p "$HOME/thunderbird-backup/default-release"

# copy stuff to backup directory
# * breaks with quotes
cp -r $HOME/.thunderbird/*.default-release/* "$HOME/thunderbird-backup/default-release"

# create archive from backup
tar -cv -I"zstd -19 -T0" -f thunderbird-backup-${currdate}.tar.zst thunderbird-backup/default-release

# remove backup dir
rm -rf "$HOME/thunderbird-backup"

# encrypt backup archive
echo "$pass" | gpg -c --batch --yes --passphrase-fd 0 thunderbird-backup-${currdate}.tar.zst

# remove unencrypted archive
rm thunderbird-backup-${currdate}.tar.zst

# put encrypted archive into backups folder
mv thunderbird-backup-${currdate}.tar.zst.gpg "$HOME/Nextcloud/backups/"

# remove more than the last 3 backups
mapfile -t old_backups < <(find "$HOME/Nextcloud/backups/" -name "thunderbird-backup-*\.tar.zst.gpg" | sort -r | tail -n +4)

for backup in "${old_backups[@]}"; do
    echo "Removing old backup. $backup"
    rm "$backup"
done
