#!/usr/bin/env bash
set -euo pipefail

if [ $# -ne 1 ]; then
    echo "Please use this script with a \"PATH\" to a folder containing Manga chapters"
    $(exit 1); echo "$?"
fi

dir="$1"
parentdir="$(dirname "$dir")"
filename="$(basename "$dir")"
# remove .epub to get output folder name
outdir="${filename%.*}"

cd "$parentdir"

#echo $parentdir
#echo $filename
#echo $outdir

rm -rf "$outdir"

# 1. extract .epub
unzip "$dir" -d "$outdir"

# 2. images under "(folder name)/OEBPS/image"
#mv "$outdir/OEBPS/image/"* "$outdir/"
mv "$outdir/images/"* "$outdir/"

# 3. delete folders "META-INF", "OEBPS" and file "mimetype"
rm -rf "$outdir/"{META-INF,OEBPS,mimetype,images,text,content.opf,page_styles.css,stylesheet.css,titlepage.xhtml,toc.ncx}

# 4. rename images to "pageXXX.(ext)"
cd "$outdir"
# if cover.jpg exists, rename it to be the first page
if [ -f cover.jpg ] || [ -f cover.jpeg ]; then
    mv cover.* 0000000000.jpg
fi
ls | cat -n | while read n f; do mv "$f" `printf "page%03d.jpg" $n`; done
