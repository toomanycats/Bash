#!/bin/bash

NEW_XDIM=$1
NEW_YDIM=$2
infile=$3
outfile=$4

convert -antialias -resample ${NEW_XDIM}x${NEW_YDIM} -interpolate nearest -median 11 ${infile} ${outfile}
