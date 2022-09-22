#!/bin/bash -e
FILE_NAME="proc_usage.txt"
# rm $FILE_NAME # overwrite
while [ ! -f ./__IMPL_DONE__ ]
do
  date >> $FILE_NAME
  echo `cat /proc/stat | grep procs_running` >> $FILE_NAME
  sleep 2
done