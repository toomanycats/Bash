#!/bin/bash

echo "Running find command to look for tar, gz, zip, bz2, 7z, xz and dmg files."
echo "Running on `/m/Raw` and `/m/RawData`, this will take several hours."

find /m/Raw /m/RawData -type f -regextype posix-extended -regex '.*?\.(tar|gz|zip|bz2|7z|xz|dmg)' 2>/dev/null 1>~/find_archives.txt

echo "Total number of archive files found:"
wc -l find_archives.txt

echo "Computing the size of each file."
cat find_archives.txt | parallel -j 4 du -S > size.txt
cat size.txt | datamash sum 1 | xargs printf "Total:%'i Bytes\n"

echo "Printing size and path of each file."
awk '{printf "%'"'"'d: %s\n", $1, $2}' size.txt | sort -n
