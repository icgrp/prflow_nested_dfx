#!/bin/bash -e
Xilinx_dir
bitstream=./checkpoint/p4_p0_subdivide.bit
xmlfile=./shell/nested/p4_p0_subdivide.xml
xclbin=./checkpoint/p4_p0_subdivide.xclbin

xclbinutil --add-section DEBUG_IP_LAYOUT:JSON:../_x/link/int/debug_ip_layout.rtd \
--add-section BITSTREAM:RAW:${bitstream} \
--force --target hw --key-value SYS:dfx_enable:true --add-section :JSON:../_x/link/int/ydma.rtd \
--add-section CLOCK_FREQ_TOPOLOGY:JSON:../_x/link/int/ydma_xml.rtd \
--add-section BUILD_METADATA:JSON:../_x/link/int/ydma_build.rtd \
--add-section EMBEDDED_METADATA:RAW:${xmlfile} \
--add-section SYSTEM_METADATA:RAW:../_x/link/int/systemDiagramModelSlrBaseAddress.json \
--key-value SYS:PlatformVBNV:xilinx_zcu102_dynamic_1_0 \
--output ${xclbin}