#!/usr/bin/env bash
set -euo pipefail

cd "$HOME/GitProjects/configs/arch-setup/packages/"

readarray -d '' packagefiles < <(find "$HOME/GitProjects/configs/arch-setup/packages/" -name "*\.txt" -print0)

for file in "${packagefiles[@]}"; do
    echo "Sorting $file"
    cat "$file" | sort >"${file}.tmp" && mv "${file}.tmp" "$file"
done
