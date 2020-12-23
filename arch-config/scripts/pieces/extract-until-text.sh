#!/bin/bash

# Script by RealStickman
# https://gitlab.com/RealStickman

file="$1"
count=1

while [[ ! $(file "$file" | grep "ASCII text") ]];
do
    if [[ $(file "$file" | grep "POSIX tar archive") ]]; then
        tar -xvOf "$file" > taroutfile"$count"
        file="taroutfile$count"
        ((count=count+1))
        echo "Using tar"
    fi
    if [[ $(file "$file" | grep "bzip2 compressed data") ]]; then
        bzip2 -dc "$file" > bzoutfile"$count"
        file="bzoutfile$count"
        ((count=count+1))
        echo "Using bzip2"
    fi
    if [[ $(file "$file" | grep "gzip compressed data") ]]; then
        mv "$file" "$file".gz
        gzip -dc "$file".gz > gzoutfile"$count"
        file="gzoutfile$count"
        ((count=count+1))
        echo "Using gzip"
    fi
done
echo "Finished"
mv "$file" "output.txt"
echo "Your content is in output.txt"
