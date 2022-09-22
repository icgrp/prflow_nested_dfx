#!/bin/bash -e
# TODO: source Vitis settings
source /tools/Xilinx/Vitis/2021.1/settings64.sh

vitis_hls -f ./tc_all_3_prj/tc_all_3/script.tcl
