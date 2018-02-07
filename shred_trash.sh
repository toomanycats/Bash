#!/usr/bin/bash
# https://askubuntu.com/questions/1002925/is-it-possible-to-change-the-trashcan-to-use-the-shred-function

inotifywait -m ~/.local/share/Trash/Files -e moved_to -rq --format '%w%f' |
while read file; do
    shred $file
done
