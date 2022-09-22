#!/bin/bash -e
# TODO: source Vitis settings
source /tools/Xilinx/Vitis/2021.1/settings64.sh

vitis_hls -f ./tc_1_2_prj/tc_1_2/script.tcl
