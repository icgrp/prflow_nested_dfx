#!/bin/bash -e
FILE_NAME="monitor.txt"

IS_RUNNING=false
if [ ! -f "__done__" ] ; then
  IS_RUNNING=true
fi


while [ "$IS_RUNNING" == true ]
do
  date >> $FILE_NAME
  # echo "$IS_RUNNING"
  echo q | htop | aha --black --line-fix > htop.html
  VALUES=( $(python2 parse_htop.py ) )
  # echo ${VALUES[0]}
  # echo ${VALUES[1]}
  echo "mem load: " ${VALUES[0]} >> $FILE_NAME # current mem load
  echo "num of running threads: " ${VALUES[1]} >> $FILE_NAME # num of running threads
  sleep 2

  IS_RUNNING=false

  if [ ! -f "__done__" ] ; then
    IS_RUNNING=true
  fi
done
