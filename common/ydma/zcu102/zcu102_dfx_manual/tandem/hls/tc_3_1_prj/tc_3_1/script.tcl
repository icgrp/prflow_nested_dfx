set logFileId [open ./runLogtc_3_1.log "w"]
set_param general.maxThreads 8 
set start_time [clock seconds]
open_project tc_3_1_prj
set_top tc_3_1
add_files ../src/tandem_src/tc_3_1.cpp
add_files ../src/host/typedefs.h
open_solution "tc_3_1"
set_part {xczu9eg-ffvb1156-2-e}
create_clock -period 4 -name default
#csim_design
csynth_design
#cosim_design -trace_level all -tool xsim
#export_design -rtl verilog -format ip_catalog
set end_time [clock seconds]
set total_seconds [expr $end_time - $start_time]
puts $logFileId "hls: $total_seconds seconds"

exit
