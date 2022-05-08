#!/usr/bin/env bash
set -euo pipefail

# 1. extract .epub
# 2. images under "(folder name)/OEBPS/image"
# 3. rename images to "pageXXX.(ext)"
# 4. move to "(folder name)"
# 5. delete folders "META-INF", "OEBPS" and file "mimetype"
