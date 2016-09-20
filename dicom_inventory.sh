#!/bin/bash

function get_path
{
    input="$1"
    path="$(dirname "$input")"
    echo $path

}

function get_filename
{
    input="$1"
    fn=$(basename "$input")
    echo $fn
}

function get_file_ext
{
    input="$1"
    #base="${input##*/}"
    base=$(basename "$input")
    test_=$(echo "$base" | grep -c "\.")

    if [ $test_ = 0 ];then
        echo "NONE"
    else
        #ext="${base##.*}"
        ext=$(echo "$base" | rev | cut -d. -f 1 | rev)
    fi

    echo ${ext}
}

function file_info
{
    input="$1"
    info=$(file -b "$input")
    echo $info
}

function get_byte_size
{
    input="$1"
    size=$(du -b "$input" | cut -f 1)
    echo "${size}"
}

function get_study_desc
{
    input="$1"
    desc=$(dcmdump $input | grep -i "studydesc" | grep -Eo "\[.*?\]"| sed 's/\[//1' | sed 's/\]//1')
    echo $desc
}

function get_series_desc
{
    input="$1"
    desc=$(dcmdump $input | grep -i "seriesdesc" | grep -Eo "\[.*?\]" | sed 's/\[//1' | sed 's/\]//1')
    echo $desc
}
############### starts here ######################

file_="$1"
ext=$(get_file_ext "${file_}")
info=$(file_info "${file_}")
size=$(get_byte_size "${file_}")
fn=$(get_filename "${file_}")
dirname=$(get_path "${file_}")
study_desc=$(get_study_desc "${file_}")
series_desc=$(get_series_desc "${file_}")

printf "\"${file_}\",\"${ext}\",\"${info}\",\"${size}\",\"${fn}\",\"${dirname}\",\"${study_desc}\",\"${series_desc}\"\n"
