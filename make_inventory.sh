#!/bin/bash

DATA_ROOT="$1"

OUTPUT_ROOT="$PWD"
INVENTORY="$OUTPUT_ROOT/inventory.csv"
DICOM_LIST="$OUTPUT_ROOT/dicom.list"

if [ $# -lt 1 ];then
    echo "Usage:$0 <data root>"
    exit
fi


function die {
    TAG="$1"
    echo "Tag:$TAG, This dicom:$DCM"
    exit 1
}

function cleanup {
    if [[ ! -z $TEMP && -f $TEMP ]]; then
        rm $TEMP
    fi
}

trap cleanup EXIT

function get_int_tag {
    TAG="$1"
    VALUE="$(grep -m 1 "$TAG" $TEMP | awk '{print $3}')"
    if [ -z "$VALUE" ]; then
        die "$TAG"
    fi

    echo "$VALUE"
}

function get_char_tag {
    TAG="$1"
    VALUE="$(grep -m 1 "$TAG" $TEMP | grep -oP '\[.*\]' | tr -d '\[\]')"
    if [ -z "$VALUE" ]; then
        die "$TAG"
    fi
    echo "$VALUE"
}

function isDicom {
    DICOM="$1"
    CNT=$(hexdump -C -s 128 -n 4 "$DICOM" | grep -c DICM)
    if [ $CNT -eq 1 ]; then
        echo TRUE
    else
        echo FALSE
    fi
}

function format_date {
    DATE="$1"
    # Don't use shell char strings.
    YEAR=$(echo $DATE | cut -c 1-4)
    MON=$(echo $DATE | cut -c 5-6)
    DAY=$(echo $DATE | cut -c 7-8)
    echo "$YEAR-$MON-$DAY"
}

function format_time {
    TIME="$1"
    HOUR=$(echo $TIME | cut -c 1-2)
    MIN=$(echo $TIME | cut -c 3-4)
    SEC=$(echo $TIME | cut -c 5-6)
    echo "$HOUR:$MIN:$SEC"
}

function make_date_time_string {
    DATE=$(get_char_tag '(0008,0021)')
    TIME=$(get_char_tag '(0008,0031)')

    DATE_F="$(format_date $DATE)"
    TIME_F="$(format_time $TIME)"

    echo "${DATE_F}T${TIME_F}"
}

function make_row {
    DCM="$1"
    TEMP=$(mktemp)
    dcmdump  "$DCM" > $TEMP

    STUDY=$(get_char_tag '(0020,0010)')
    PATNAME=$(get_char_tag '(0010,0010)')
    PHYNAME=$(get_char_tag '(0010,0020)')
    PATID=$(get_char_tag '(0008,0090)')
    AGE=$(get_char_tag '(0010,1010)')
    SD=$(get_char_tag '(0008,103e)')
    MOD=$(get_char_tag '(0008,0060)')
    INST=$(get_char_tag '(0008,0080)')
    MAN=$(get_char_tag '(0008,0070)')
    FIRM=$(get_char_tag '(0018,1020)')
    ROWS=$(get_int_tag '(0028,0010)')
    COLS=$(get_int_tag '(0028,0011)')
    DATETIME=$(make_date_time_string)
    TR=$(get_char_tag '(0018,0080)')
    STYDES=$(get_char_tag '(0008,1030)')
    STUID=$(get_char_tag '(0020,000d)')
    SERUID=$(get_char_tag '(0020,000e)')
    ACQN=$(get_char_tag '(0020,0012)')
    TYPE=$(get_char_tag '(0008,0008)')
    SERNUM=$(get_char_tag '(0020,0011)')
    echo "\"$STUDY\",\"$PATNAME\",\"$PHYNAME\",\"$PATID\",\"$AGE\",\"$SD\",\"$MOD\",\"$INST\",\"$MAN\",\"$FIRM\",\"$ROWS\",\"$COLS\",\"$DATETIME\",\"$TR\",\"$STYDES\",\"$STUID\",\"$SERUID\",\"$ACQN\",\"$TYPE\",\"$SERNUM\",\"$DCM\"" | tee -a $INVENTORY
    cleanup $TEMP
}

## main ##

if [ ! -d "$DATA_ROOT" ]; then
    >&2 echo "Data root does not exist."
    exit
fi

if [ ! -f $DICOM_LIST ]; then
    find $DATA_ROOT -type f > $DICOM_LIST
fi


echo "\"STUDY\",\"PATNAME\",\"PHYNAME\",\"PATID\",\"AGE\",\"SD\",\"MOD\",\"INST\",\"MAN\",\"FIRM\",\"ROWS\",\"COLS\",\"DATETIME\",\"TR\",\"STDDES\",\"STUID\",\"SERUID\",\"ACQN\",\"TYPE\",\"SERNUM\",\"DCM\"" | tee  $INVENTORY

while read DCM; do
    if [ $(isDicom "$DCM") = 'FALSE' ];then
        continue
    fi
    make_row "$DCM"
done < $DICOM_LIST
echo "Inventory complete."
exit
