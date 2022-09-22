#!/bin/bash -e

g++ ./src/host.cpp -o host  

start=$(date +%s.%N) 

./host $1

dur=$(echo "$(date +%s.%N) - $start" | bc)
printf "run: %.3f seconds" $dur > runtime_${1}.log
printf ""







