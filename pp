#!/bin/bash

var=$1

echo $var | sed 's/:/\n/g' | sort | uniq

exit 0
