#!/bin/bash
function success
{
if [ $? -eq 0 ]; then
    print "successful"
    echo "true"
else
    echo "false"
fi
}

function get_zombie_parents
{
    # newline delimited output
    pids=$(ps -A -ostat,ppid | grep -e '[zZ]'| awk '{ print $2 }')
    echo ${pids}
}

pids=$(get_zombie_parents)
if [ -z ${pids} ]; then
    echo "No zombie processes found."
    exit 0;
fi

while read pid; do
    kill -HUP ${pid} || kill ${pid} || kill -9 ${pid}
    outcome=$(success)
    if [ ${outcome} = "true" ];then
        echo "${pid} brought down."
    else
        echo "${pid} failed to terminate."
    fi
done <<< $(get_zombie_parents)
