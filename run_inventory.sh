#!/bin/bash
######################################
# Author : Daniel Cuneo
# Creation Date : 8-31-2015
######################################

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

make_inventory_header.sh > $output

find ${root_dir} -type f | parallel -d"\n" -n 1 --jobs 6  'inventory.sh {}' >> $output

# remove \r that can occur from Windoze
sed -i 's/\r//g' $output

exit 0
