#!/bin/bash

set -euo pipefail

# redetects PulseAudio outputs
pacmd unload-module module-udev-detect && pacmd load-module module-udev-detect

exit 0
