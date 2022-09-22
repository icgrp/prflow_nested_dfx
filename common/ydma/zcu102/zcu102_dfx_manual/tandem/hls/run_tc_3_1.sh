#!/bin/bash -e
# TODO: source Vitis settings
source /tools/Xilinx/Vitis/2021.1/settings64.sh

vitis_hls -f ./tc_3_1_prj/tc_3_1/script.tcl
