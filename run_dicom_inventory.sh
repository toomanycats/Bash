#!/bin/bash

root_dir="$1"
output="$2"

function die
{
    exit 1;
}

if [ $# -ne 2 ];then
    echo -e "Usage:root_dir, out_path"
    exit 2
fi

trap die SIGINT

printf "\"full_path\",\"ext\",\"type\",\"size\",\"basename\",\"dirname\",\"study_desc\",\"series_desc\"" > $output

# parallel not installed on ucsd machine
#find ${root_dir} -type f | parallel -d"\n" -n 1 --jobs 4  'inventory.sh {}' >> $output

for f in $(find ${root_dir} -type f);do
    dicome_inventory.sh >> $output
done

# remove \r that can occur from Windoze
sed -i 's/\r//g' $output

exit 0
