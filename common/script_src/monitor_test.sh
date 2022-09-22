#!/bin/bash -e
FILE_NAME="monitor.txt"

echo q | htop | aha --black --line-fix > htop.html
VALUES=( $(python2 parse_htop.py ) )
# echo ${VALUES[0]}
# echo ${VALUES[1]}
date >> $FILE_NAME
echo "mem load: " ${VALUES[0]} >> $FILE_NAME # current mem load
echo "num of running threads: " ${VALUES[1]} >> $FILE_NAME # num of running threads