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
    desc=$(dcmdump $input | grep -i "studydesc")
    desc=$(clean "$desc")
    echo $desc
}

function get_series_desc
{
    input="$1"
    series=$(dcmdump $input | grep -i "seriesdesc" )
    series=$(clean "$series")
    echo $series
}

function get_scanner_manuf
{
    input="$1"
    manu=$(dcmdump "$input" | grep -iw 'manufacturer')
    manu=$(clean "$manu")
    echo "$manu"
}

function get_scanner_model
{
    input="$1"
    model=$(dcmdump "$input" | grep -i 'manufacturermodelname')
    model=$(clean "$model")
    echo "$model"
}

function get_scanner_serial_num
{
    input="$1"
    serial=$(dcmdump "$input" | grep -i "deviceserialnumber")
    serial=$(clean "$serial")
    echo "$serial"
}

function clean
{
    input="$1"
    out=$(echo "$input" | grep -oP "\[\K(.*?\])" | sed 's/\]//1')
    echo "$out"
}

function is_dicom
{
    input="$1"
    bool=$(echo "$input" | grep -ic "dicom")
    if [ $bool -gt 0 ];then
        bool="true"
    else
        bool="false"
    fi

    echo $bool
}
############### starts here ######################

file_="$1"

ext=$(get_file_ext "${file_}")
info=$(file_info "${file_}")
size=$(get_byte_size "${file_}")
fn=$(get_filename "${file_}")
dirname=$(get_path "${file_}")

dicom_bool=$(is_dicom "${info}")
if [[ $dicom_bool == "true" ]];then

    study=$(get_study_desc "${file_}" )
    series=$(get_series_desc "${file_}")
    manu=$(get_scanner_manuf "${file_}" )
    model=$(get_scanner_model "${file_}")
    serialno=$(get_scanner_serial_num "${file_}")
else
    study="NULL"
    series="NULL"
    manu="NULL"
    model="NULL"
    serialno="NULL"
fi

printf "\"${file_}\",\"${ext}\",\"${info}\",\"${size}\",\"${fn}\",\"${dirname}\",\"${study}\",\"${series}\",\"${manu}\",\"${model}\",\"${serialno}\"\n"




