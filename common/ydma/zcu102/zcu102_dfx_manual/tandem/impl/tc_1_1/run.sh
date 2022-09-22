#!/bin/bash -e
source /tools/Xilinx/Vitis/2021.1/settings64.sh
vivado -mode batch -source  impl_tc_1_1.tcl
