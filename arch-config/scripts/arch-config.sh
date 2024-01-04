#!/usr/bin/env bash

set -euo pipefail

# function to keep sudo from timing out
function func_dont_timeout {
    while true; do
        sudo -v
        sleep 60
    done
}

# check if user is root
if [ "$EUID" -ne 0 ]; then
    sudo -v
fi

# keep sudo active in background
func_dont_timeout &

cat <<EOF
############################################################
###################### INSTALL CONFIG ######################
############################################################
EOF

cat <<EOF
########################################
################ Setup  ################
########################################
EOF

# get script directory
scriptloc="$BASH_SOURCE"

# Use temporary directory for download
tempdir="$(mktemp -d)"

echo "Checking config file"

#clone this repo
git clone -b rewrite-in-python https://gitea.exu.li/realstickman/configs.git "$tempdir" &>/dev/null

# check if the install scripts are the same
# NOTE Arguments get passed automatically now
if ! cmp --silent "$scriptloc" "$HOME/scripts/arch-config.sh"; then
    echo Removed old config file and launched new one.
    cp "$tempdir/arch-config/scripts/arch-config.sh" "$HOME/scripts/" && bash ~/scripts/arch-config.sh "$@"
fi

cat <<EOF
########################################
############## Start Setup #############
########################################
EOF

# Collect all PIDs of background processes that should be waited for
pids=""

# call user script
python "$tempdir/arch-config/scripts/config-user.py" &
pids="$pids $!"

# call root script
bash "$tempdir/arch-config/scripts/config-root.sh" &
pids="$pids $!"

# wait for all background jobs to finish
wait $pids && echo "Finished background jobs"

cat <<EOF
########################################
############### Finished ###############
########################################
EOF

#output
echo -e "\033[38;2;20;200;20mFinished updating everything!\033[0m"
echo Launching new shell!

# reminder for enable additional gpu features for corectrl with amd gpus
if [[ $(pacman -Q corectrl) ]]; then
    echo -e "\033[38;2;200;20;20mRemember to set \"amdgpu.ppfeaturemask=0xffffffff\" in the kernel!!\033[0m"
fi

# reload user default shell
exec "$(getent passwd $LOGNAME | cut -d: -f7)"

# exit successfully
exit 0
