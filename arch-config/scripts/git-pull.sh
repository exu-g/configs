#!/bin/bash

set -euo pipefail

cd "$HOME/GitProjects/config"
git fetch --all
git pull

cd "$HOME/GitProjects/grab"
git fetch --all
git pull

cd "$HOME/GitProjects/setup"
git fetch --all
git pull

cd "$HOME/GitProjects/setup-pinephone"
git fetch --all
git pull
