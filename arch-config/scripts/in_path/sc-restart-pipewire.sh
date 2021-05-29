#!/usr/bin/env bash
set -euo pipefail

systemctl --user restart --now pipewire.socket
