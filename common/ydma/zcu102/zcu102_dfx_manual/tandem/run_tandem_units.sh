#!/bin/bash

pids=""

cd hls
./run_tc_1_1.sh &
pids="$pids $!"
./run_tc_1_2.sh &
pids="$pids $!"
./run_tc_2_1.sh &
pids="$pids $!"
./run_tc_2_2.sh &
pids="$pids $!"
./run_tc_3_1.sh &
pids="$pids $!"
./run_tc_3_2.sh &
pids="$pids $!"
./run_tc_all_1.sh &
pids="$pids $!"
./run_tc_all_2.sh &
pids="$pids $!"
./run_tc_all_3.sh &
pids="$pids $!"
# echo $PWD
wait $pids
cd ..

pids=""
cd syn
cd t_1 && ./run.sh &
pids="$pids $!"
cd t_2 && ./run.sh &
pids="$pids $!"
cd t_3 && ./run.sh &
pids="$pids $!"
cd tc_1_1 && ./run.sh &
pids="$pids $!"
cd tc_1_2 && ./run.sh &
pids="$pids $!"
cd tc_2_1 && ./run.sh &
pids="$pids $!"
cd tc_2_2 && ./run.sh &
pids="$pids $!"
cd tc_3_1 && ./run.sh &
pids="$pids $!"
cd tc_3_2 && ./run.sh &
pids="$pids $!"
cd tc_all_1 && ./run.sh &
pids="$pids $!"
cd tc_all_2 && ./run.sh &
pids="$pids $!"
cd tc_all_3 && ./run.sh &
pids="$pids $!"
# echo $PWD
wait $pids
cd ../

python overwrite_impl_tcl.py
cd impl
pids=""
cd t_1 && ./run.sh &
pids="$pids $!"
cd t_2 && ./run.sh &
pids="$pids $!"
cd t_3 && ./run.sh &
pids="$pids $!"
cd tc_1_1 && ./run.sh &
pids="$pids $!"
cd tc_1_2 && ./run.sh &
pids="$pids $!"
cd tc_2_1 && ./run.sh &
pids="$pids $!"
cd tc_2_2 && ./run.sh &
pids="$pids $!"
cd tc_3_1 && ./run.sh &
pids="$pids $!"
cd tc_3_2 && ./run.sh &
pids="$pids $!"
cd tc_all_1 && ./run.sh &
pids="$pids $!"
cd tc_all_2 && ./run.sh &
pids="$pids $!"
cd tc_all_3 && ./run.sh &
pids="$pids $!"
wait $pids
cd ../

cd ./bits
./run_t_1.sh
./run_t_2.sh
./run_t_3.sh
./run_tc_1_1.sh
./run_tc_1_2.sh
./run_tc_2_1.sh
./run_tc_2_2.sh
./run_tc_3_1.sh
./run_tc_3_2.sh
./run_tc_all_1.sh
./run_tc_all_2.sh
./run_tc_all_3.sh
cd ..