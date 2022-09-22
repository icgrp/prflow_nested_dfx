#!/bin/bash

# Exit when any command fails
set -e
#source /tools/Xilinx/Vitis/2021.1/settings64.sh
#source /opt/xilinx/xrt/setup.sh

source sourceMe
# Make sure everything is up to date
make all 

# Run the application in HW emulation mode
#XCL_EMULATION_MODE=sw_emu ./app.exe ydma.xclbin 

