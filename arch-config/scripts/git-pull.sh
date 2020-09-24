#!/bin/bash

cd "$HOME/GitProjects/config" || exit
git pull

cd "$HOME/GitProjects/grab" || exit
git pull
git checkout testing

cd "$HOME/GitProjects/setup" || exit
git pull

cd "$HOME/GitProjects/setup-pinephone" || exit
git pull
