#!/bin/bash

rsync -hua --stats --progress --exclude git* --exclude ".*_history" --exclude anaconda --exclude .cache --exclude nltk_data  ~ /media/daniel/BACKUPFAT32/System76HomeBU

