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

trap die SIGINT ERR

printf "\"full_path\",\"ext\",\"info\",\"size\",\"basename\",\"dirname\",\"study_desc\",\"series_desc\",\"manuf\",\"model\",\"serialno\"" > $output

# from dicom_inventory.sh
#printf "\"${file_}\",\"${ext}\",\"${info}\",\"${size}\",\"${fn}\",\"${dirname}\",\"${study}\",\"${series}\",\"${manu}\",\"${model}\",\"${serialno}\"\n"

find ${root_dir} -type f | parallel -d"\n" -n 1 --jobs 18 'dicom_inventory.sh {}' >> $output

# remove \r that can occur from Windoze
sed -i 's/\r//g' $output

exit 0
