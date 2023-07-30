#!/bin/bash
if [ -z "$1" ]
then
    echo "Port not specified"
else
    greparray=$(lsof -i tcp:$1 | grep -Eo "\s(\d{5})\s")
    for pid in $greparray
    do
        kill -9 $pid
        echo $pid
    done
fi