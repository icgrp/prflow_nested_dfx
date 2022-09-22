set top_name leaf_quad_2

# set dir "./src4level2/leaf"
# set contents [glob -nocomplain -directory $dir *]
# foreach item $contents {
#   if { [regexp {.*\.tcl} $item] } {
#     source $item
#   } else {
#     add_files -norecurse $item
#   }
# }

add_files ./src4level2/leaf/$top_name.v

set_param general.maxThreads  8
set_property XPM_LIBRARIES {XPM_CDC XPM_MEMORY XPM_FIFO} [current_project]
# set logFileId [open ./runOOC.log "w"]
# set start_time [clock seconds]
set_param general.maxThreads  8 
synth_design -top $top_name -part xczu9eg-ffvb1156-2-e -mode out_of_context
write_checkpoint -force ./checkpoint/$top_name.dcp
# set end_time [clock seconds]
# set total_seconds [expr $end_time - $start_time]
# puts $logFileId "syn: $total_seconds seconds"
report_utilization -hierarchical > utilization.rpt

