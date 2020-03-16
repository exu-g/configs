#!/bin/bash

git clone --recurse-submodules https://github.com/flightlessmango/MangoHud.git
cd ~/MangoHud
bash build.sh package #bash build.sh install
