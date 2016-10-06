#!/bin/bash
# build rudimentary DB row in CSV format for
# MRI volumnes, either NiFTI (.nii.gz) or (.nii)

function cleanup
{
    if [ -e $tempfile ];then
        rm $tempfile 2> /dev/null
    fi
}

trap cleanup ERR SIGINT exit

function get_file_ext
{
    input="$1"
    base=$(basename "$input")

    test=$(echo $base | rev | cut -d. -f 1,2 | rev)
    if [[ $test == "nii.gz" ]];then
        echo "nii_gz"
    else
        test=$(echo $base | rev | cut -d. -f 1 | rev)
        if [[ $test == "nii" ]];then
            echo "nii"
        else
            echo ""
        fi
   fi
}

function get_byte_size
{
    input="$1"
    size=$(du -b "$input" | cut -f 1)
    echo "${size}"
}


file_="$1"
ext=$(get_file_ext "${file_}")
size=$(get_byte_size "${file_}")

tempfile=$(mktemp)
fslhd "$file_" 2> /dev/null 1>> $tempfile
while read line;do
    out+="\""
    out+=$(echo $line | grep -oP "\S+\s+\K(.*)")
    out+="\","
done < $tempfile

printf "\"$file_\",\"$ext\",\"$size\",$out\n"

### make a header ###
#    while read line;do
#    out+="\""
#    out+=$(echo $line | grep -oP "^\S+")
#    out+="\""
#    out+=","
#done <<< $(fslhd $p)

