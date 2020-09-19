#!/bin/bash

# redetects PulseAudio outputs
pacmd unload-module module-udev-detect && pacmd load-module module-udev-detect
