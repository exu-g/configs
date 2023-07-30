#!/usr/bin/env bash
set -euo pipefail

# help message
fn_help() {
    cat <<EOF
Helper script to convert multiple XML-files in the camt.053 format into OFX files with sensible filenames
This script requires ofxstatement and ofxstatement-iso20022 to be installed as well as configured

Use like this:
./statement-convert.sh (profile) (path)

profile: Name of the configuration profile in the ofxstatement config
path:    Folder path containing one or more XML-files to be converted
EOF
}

# 2 parameters, profile and path
if [ $# -ne 2 ]; then
    fn_help
    exit 1
fi

profile="$1"
path="$2"

# find all xml files in the folder
readarray -d '' xmlfiles < <(find "$path" -maxdepth 1 -name "*\.xml" -print0)

for file in "${xmlfiles[@]}"; do
    # Takes a path like this
    # /home/exu/Documents/camt.053_SPS_08_083522212930_ND_0835222129300000_20230309_005134241_005.xml
    # And converts it into this new path
    # /home/exu/Documents/statement_20230309.ofx
    outfile="$(dirname "$file")/statement_$(basename "$file" | cut -d_ -f7).ofx"
    ofxstatement convert -t "$1" "$file" "$outfile"
done
