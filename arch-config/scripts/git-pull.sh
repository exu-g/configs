#!/bin/bash

set -euo pipefail

if [ ! -d "$HOME/GitProjects" ]; then
    mkdir "$HOME/GitProjects"
fi

WORKPATH="$HOME/GitProjects"

if [ ! -d "$HOME/GitProjects/config" ]; then
    git -C $WORKPATH clone git@gitlab.com:RealStickman-arcolinux/config.git
fi
cd "$HOME/GitProjects/config"
git fetch --all
git pull

if [ ! -d "$HOME/GitProjects/ffmpeg-lower-vol" ]; then
    git -C $WORKPATH clone git@gitlab.com:RealStickman/ffmpeg-lower-vol.git
fi
cd "$HOME/GitProjects/ffmpeg-lower-vol"
git fetch --all
git pull

if [ ! -d "$HOME/GitProjects/grab" ]; then
    git -C $WORKPATH clone git@gitlab.com:RealStickman/grab.git
fi
cd "$HOME/GitProjects/grab"
git fetch --all
git pull

if [ ! -d "$HOME/GitProjects/powershell-scripting" ]; then
    git -C $WORKPATH clone git@gitlab.com:RealStickman/powershell-scripting.git
fi
cd "$HOME/GitProjects/powershell-scripting"
git fetch --all
git pull

if [ ! -d "$HOME/GitProjects/setup" ]; then
    git -C $WORKPATH clone git@gitlab.com:RealStickman-arcolinux/setup.git
fi
cd "$HOME/GitProjects/setup"
git fetch --all
git pull

if [ ! -d "$HOME/GitProjects/setup-pinephone" ]; then
    git -C $WORKPATH clone git@gitlab.com:RealStickman/setup-pinephone.git
fi
cd "$HOME/GitProjects/setup-pinephone"
git fetch --all
git pull

if [ ! -d "$HOME/GitProjects/website" ]; then
    git -C $WORKPATH clone git@gitlab.com:RealStickman/website.git
fi
cd "$HOME/GitProjects/website"
git fetch --all
git pull

exit 0
