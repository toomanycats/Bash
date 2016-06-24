#!/bin/bash
######################################
# Author : Daniel Cuneo
# Creation Date : 8-31-2015
######################################


function get_file_ext
{
    input="$1"
    base="${input##*/}"
    #base=$(basename "$input")
    test_=$(echo "$base" | grep -c "\.")

    if [ $test_ = 0 ];then
        echo "NONE"
    else
        ext="${base##.*}"
        #ext=$(echo "$base" | rev | cut -d. -f 1 | rev)
    fi

    echo ${ext}
}

function file_type
{
    input="$1"
    type_=$(file "$input" | cut -d: -f 2 | sed 's/\W/ /g')
    echo $type_
}

function get_byte_size
{
    input="$1"
    size=$(du -b "$input" | cut -f 1)
    echo "${size}"
}

function is_text
{
    input="$1"
    bool=$(echo "$input" | grep -icw "text")
    echo $bool

}

# keep this for files we don't know the lang for but need tot lines still
function tot_lines
{
    input="$1"
    tot=$(cat "$input" | wc -l)
    echo $tot
}

# sloc has been fixed to return correct values now
# altho it's confusing to return 4 values at once, it's
# faster so we will do so, becareful with the header.

#Language  Files  Code  Comment  Blank  Total
#  Total      1     7       22      5     29
#      C      1     7       22      5     29

function get_sloc
{
    file_="$1"
    # to print double quote, need annoyng escape seq: "\""  b/c ' doesn't allow escapes with \
    sloc_=$(sloc "${file_}" | awk 'FNR == 2 {print  "\""$3"\"" "," "\""$4"\"" "," "\""$5"\"" "," "\""$6"\""}')
    echo $sloc_
}


############### starts here ######################

file_="$1"
ext=$(get_file_ext "${file_}")
type_=$(file_type "${file_}")
size=$(get_byte_size "${file_}")
text_bool=$(is_text "${type_}")

if [[ $text_bool -eq 0 ]];then
    sloc_=0
    comments=0
    blank=0
    tot_lines=0

elif [[ $text_bool -gt 0 && $ext == "NONE" ]];then
    sloc_=0
    comments=0
    blank=0
    tot_lines=$(tot_lines "${file_}")
    printf "\"${file_}\",\"${text_bool}\",\"${ext}\",\"${type_}\",\"${size}\",\"${sloc_}\",\"${comments}\",\"${blank}\",\"${tot_lines}\"\n"

else
    # in this case, the sloc var contains all four values: sloc, comments, blank, tot lines
    sloc_=$(get_sloc "${file_}")
    printf "\"${file_}\",\"${text_bool}\",\"${ext}\",\"${type_}\",\"${size}\",${sloc_}\n"
fi



