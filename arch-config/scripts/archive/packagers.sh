#!/bin/bash

pacman -Qi |
  grep -P '^Pack(ag)?(e)?r' |
  cut -d: -f2 |
  sort |
  uniq -c |
  sort -n |
  sed 's/^ *//;s/  /:/' |
  awk -F: "{printf \"%5.1f%%  \",\
      100 * \$1 / $(pacman -Qq | wc -l);\
      \$1=\"\" }1"

exit 0
