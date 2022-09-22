#!/bin/bash -e
FILE_NAME="mem_usage.txt"
# rm $FILE_NAME # overwrite
while [ ! -f ./__IMPL_DONE__ ]
do
  date >> $FILE_NAME
  echo `cat /proc/meminfo | grep Active: | sed 's/Active: //g'`/`cat /proc/meminfo | grep MemTotal: | sed 's/MemTotal: //g'` >> $FILE_NAME
  sleep 2
done