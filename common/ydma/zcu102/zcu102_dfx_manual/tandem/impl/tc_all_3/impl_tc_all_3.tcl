# 
# Report generation script generated by Vivado
# 

set page_num PAGE_NUM_MODIFY
set operator tc_all_3
# set benchmark rendering512
set page_name "page$page_num" 
set part xczu9eg-ffvb1156-2-e
set page_dcp "../../syn/${operator}/page_netlist.dcp"
set context_dcp "../../../p_${page_num}.dcp"
set inst_name "pfm_top_i/dynamic_region/ydma_1/${page_name}_inst"
set bit_name "../../bits/${operator}.bit"
set logFileId [open ./runLogImpl_${operator}.log "w"]
set place_dcp "./${page_name}_design_place.dcp"
set route_dcp "./${page_name}_design_route.dcp"

set_param general.maxThreads 8 


proc create_report { reportName command } {
  set status "."
  append status $reportName ".fail"
  if { [file exists $status] } {
    eval file delete [glob $status]
  }
  send_msg_id runtcl-4 info "Executing : $command"
  set retval [eval catch { $command } msg]
  if { $retval != 0 } {
    set fp [open $status w]
    close $fp
    send_msg_id runtcl-5 warning "$msg"
  }
}
namespace eval ::optrace {
  variable script "./scripts/pfm_top_wrapper.tcl"
  variable category "vivado_impl"
}

# Try to connect to running dispatch if we haven't done so already.
# This code assumes that the Tcl interpreter is not using threads,
# since the ::dispatch::connected variable isn't mutex protected.
if {![info exists ::dispatch::connected]} {
  namespace eval ::dispatch {
    variable connected false
    if {[llength [array get env XILINX_CD_CONNECT_ID]] > 0} {
      set result "true"
      if {[catch {
        if {[lsearch -exact [package names] DispatchTcl] < 0} {
          set result [load librdi_cd_clienttcl[info sharedlibextension]] 
        }
        if {$result eq "false"} {
          puts "WARNING: Could not load dispatch client library"
        }
        set connect_id [ ::dispatch::init_client -mode EXISTING_SERVER ]
        if { $connect_id eq "" } {
          puts "WARNING: Could not initialize dispatch client"
        } else {
          puts "INFO: Dispatch client connection id - $connect_id"
          set connected true
        }
      } catch_res]} {
        puts "WARNING: failed to connect to dispatch server - $catch_res"
      }
    }
  }
}
if {$::dispatch::connected} {
  # Remove the dummy proc if it exists.
  if { [expr {[llength [info procs ::OPTRACE]] > 0}] } {
    rename ::OPTRACE ""
  }
  proc ::OPTRACE { task action {tags {} } } {
    ::vitis_log::op_trace "$task" $action -tags $tags -script $::optrace::script -category $::optrace::category
  }
  # dispatch is generic. We specifically want to attach logging.
  ::vitis_log::connect_client
} else {
  # Add dummy proc if it doesn't exist.
  if { [expr {[llength [info procs ::OPTRACE]] == 0}] } {
    proc ::OPTRACE {{arg1 \"\" } {arg2 \"\"} {arg3 \"\" } {arg4 \"\"} {arg5 \"\" } {arg6 \"\"}} {
        # Do nothing
    }
  }
}

proc start_step { step } {
  set stopFile ".stop.rst"
  if {[file isfile .stop.rst]} {
    puts ""
    puts "*** Halting run - EA reset detected ***"
    puts ""
    puts ""
    return -code error
  }
  set beginFile ".$step.begin.rst"
  set platform "$::tcl_platform(platform)"
  set user "$::tcl_platform(user)"
  set pid [pid]
  set host ""
  if { [string equal $platform unix] } {
    if { [info exist ::env(HOSTNAME)] } {
      set host $::env(HOSTNAME)
    } elseif { [info exist ::env(HOST)] } {
      set host $::env(HOST)
    }
  } else {
    if { [info exist ::env(COMPUTERNAME)] } {
      set host $::env(COMPUTERNAME)
    }
  }
  set ch [open $beginFile w]
  puts $ch "<?xml version=\"1.0\"?>"
  puts $ch "<ProcessHandle Version=\"1\" Minor=\"0\">"
  puts $ch "    <Process Command=\".planAhead.\" Owner=\"$user\" Host=\"$host\" Pid=\"$pid\">"
  puts $ch "    </Process>"
  puts $ch "</ProcessHandle>"
  close $ch
}

proc end_step { step } {
  set endFile ".$step.end.rst"
  set ch [open $endFile w]
  close $ch
}

proc step_failed { step } {
  set endFile ".$step.error.rst"
  set ch [open $endFile w]
  close $ch
OPTRACE "impl_1" END { }
}

add_files $context_dcp 
add_files $page_dcp
set_property SCOPED_TO_CELLS { pfm_top_i/dynamic_region/ydma_1/pagePAGE_NUM_MODIFY_inst } [get_files $page_dcp]



OPTRACE "impl_1" START { ROLLUP_1 }
# used by v++ flow only
set is_post_route_phys_opt_enabled 0


set start_time [clock seconds]
OPTRACE "Phase: Init Design" START { ROLLUP_AUTO }
start_step init_design
set ACTIVE_STEP init_design
set rc [catch {
  create_msg_db init_design.pb
OPTRACE "Design Initialization: pre hook" START { }
  set src_rc [catch { 
    puts "source ./scripts/_full_init_pre.tcl"
    source ./scripts/_full_init_pre.tcl
  } _RESULT] 
  if {$src_rc} { 
    set tool_flow [get_property -quiet TOOL_FLOW [current_project -quiet]]
    if { $tool_flow eq {SDx} } { 
      send_gid_msg -id 2 -ssname VPL_TCL -severity ERROR $_RESULT
      send_gid_msg -id 3 -ssname VPL_TCL -severity ERROR "sourcing script ./scripts/_full_init_pre.tcl failed"
    } else {
      send_msg_id runtcl-1 status "$_RESULT"
      send_msg_id runtcl-2 status "sourcing script ./scripts/_full_init_pre.tcl failed"
    }
    return -code error
  }
OPTRACE "Design Initialization: pre hook" END { }
  set_param project.enablePRFlowIPI 1
  set_param bd.debug_profile.script ./.local/debug_profile_automation.tcl
  set_param ips.enableSLRParameter 2
  set_param hd.Visual 0
  set_param bd.ForceAppCoreUpgrade 1
  set_param bd.enable_dpa 1
  set_param project.loadTopLevelOOCConstrs 1
  set_param project.gatelevelSubdesign 1
  set_param place.ultrathreadsUsed 0
  set_param chipscope.maxJobs 2
  set_param compiler.enablePerformanceTrace 1
  set_param bd.skipSupportedIPCheck 1
OPTRACE "create in-memory project" START { }
  # create_project -in_memory -part xczu9eg-ffvb1156-2-e
  # set_property board_part_repo_paths {./.local/hw_platform/board} [current_project]
  # set_property board_part xilinx.com:zcu102:part0:3.4 [current_project]
  set_property design_mode GateLvl [current_fileset]
  set_param project.singleFileAddWarning.threshold 0
OPTRACE "create in-memory project" END { }
OPTRACE "set parameters" START { }
  # set_property webtalk.parent_dir ./prj/prj.cache/wt [current_project]
  # set_property tool_flow SDx [current_project]
  # set_property parent.project_path ./prj/prj.xpr [current_project]
  set_property ip_repo_paths {
  ./.local/hw_platform/iprepo
  /home/ylxiao/ws_211/prflow_riscv/workspace/F001_overlay/ydma/zcu102/_x/link/int/xo/ip_repo/xilinx_com_hls_ydma_1_0
  ./.local/hw_platform/iprepo
  /opt/Xilinx/Vitis/2021.1/data/cache/xilinx
  ./.local/hw_platform/ipcache
  /opt/Xilinx/Vitis/2021.1/data/ip
} [current_project]
  update_ip_catalog
  set_property ip_output_repo /home/ylxiao/ws_211/prflow_riscv/workspace/F001_overlay/ydma/zcu102/.ipcache [current_project]
  set_property ip_cache_permissions {read write} [current_project]
  set_property XPM_LIBRARIES {XPM_CDC XPM_FIFO XPM_MEMORY} [current_project]
OPTRACE "set parameters" END { }
OPTRACE "add files" START { }
  # add_files -quiet ./.local/hw_platform/hw_bb_locked.dcp
  set_param project.isImplRun true
  # add_files -quiet ./prj/prj.srcs/my_rm/bd/pfm_dynamic/pfm_dynamic.bd
  set_param project.isImplRun false
  # add_files -quiet ./prj/prj.runs/my_rm_synth_1/pfm_dynamic.dcp

OPTRACE "read constraints: implementation" START { }
  read_xdc ./xdc/dynamic_impl.xdc
  read_xdc ./xdc/dont_partition.xdc
  read_xdc ./xdc/_post_sys_link_gen_constrs.xdc
OPTRACE "read constraints: implementation" END { }
  # read_xdc -mode out_of_context -cells pfm_top_i/dynamic_region ./output/pfm_dynamic_ooc_copy.xdc
  # set_property processing_order LATE [get_files ./output/pfm_dynamic_ooc_copy.xdc]
OPTRACE "add files" END { }
link_design -mode default -reconfig_partitions { pfm_top_i/dynamic_region/ydma_1/pagePAGE_NUM_MODIFY_inst } -part $part -top pfm_top_wrapper
OPTRACE "gray box cells" START { }
OPTRACE "gray box cells" END { }
OPTRACE "Design Initialization: post hook" START { }
  set src_rc [catch { 
    puts "source ./scripts/_full_init_post.tcl"
    source ./scripts/_full_init_post.tcl
  } _RESULT] 
  if {$src_rc} { 
    set tool_flow [get_property -quiet TOOL_FLOW [current_project -quiet]]
    if { $tool_flow eq {SDx} } { 
      send_gid_msg -id 2 -ssname VPL_TCL -severity ERROR $_RESULT
      send_gid_msg -id 3 -ssname VPL_TCL -severity ERROR "sourcing script ./scripts/_full_init_post.tcl failed"
    } else {
      send_msg_id runtcl-1 status "$_RESULT"
      send_msg_id runtcl-2 status "sourcing script ./scripts/_full_init_post.tcl failed"
    }
    return -code error
  }
OPTRACE "Design Initialization: post hook" END { }
OPTRACE "init_design_reports" START { REPORT }
OPTRACE "init_design_reports" END { }
OPTRACE "init_design_write_hwdef" START { }
OPTRACE "init_design_write_hwdef" END { }
  close_msg_db -file init_design.pb
} RESULT]
if {$rc} {
  step_failed init_design
  return -code error $RESULT
} else {
  end_step init_design
  unset ACTIVE_STEP 
}

OPTRACE "Phase: Init Design" END { }
set end_time [clock seconds]
set total_seconds [expr $end_time - $start_time]
puts $logFileId "read_checkpoint: $total_seconds seconds"




set start_time [clock seconds]
OPTRACE "Phase: Opt Design" START { ROLLUP_AUTO }
start_step opt_design
set ACTIVE_STEP opt_design
set rc [catch {
  create_msg_db opt_design.pb
OPTRACE "Opt Design: pre hook" START { }
  set src_rc [catch { 
    puts "source ./scripts/_full_opt_pre.tcl"
    source ./scripts/_full_opt_pre.tcl
  } _RESULT] 
  if {$src_rc} { 
    set tool_flow [get_property -quiet TOOL_FLOW [current_project -quiet]]
    if { $tool_flow eq {SDx} } { 
      send_gid_msg -id 2 -ssname VPL_TCL -severity ERROR $_RESULT
      send_gid_msg -id 3 -ssname VPL_TCL -severity ERROR "sourcing script ./scripts/_full_opt_pre.tcl failed"
    } else {
      send_msg_id runtcl-1 status "$_RESULT"
      send_msg_id runtcl-2 status "sourcing script ./scripts/_full_opt_pre.tcl failed"
    }
    return -code error
  }
OPTRACE "Opt Design: pre hook" END { }
OPTRACE "read constraints: opt_design" START { }
OPTRACE "read constraints: opt_design" END { }
OPTRACE "opt_design" START { }
  opt_design 
OPTRACE "opt_design" END { }
OPTRACE "read constraints: opt_design_post" START { }
OPTRACE "read constraints: opt_design_post" END { }
OPTRACE "Opt Design: post hook" START { }
  set src_rc [catch { 
    puts "source ./scripts/_full_opt_post.tcl"
    source ./scripts/_full_opt_post.tcl
  } _RESULT] 
  if {$src_rc} { 
    set tool_flow [get_property -quiet TOOL_FLOW [current_project -quiet]]
    if { $tool_flow eq {SDx} } { 
      send_gid_msg -id 2 -ssname VPL_TCL -severity ERROR $_RESULT
      send_gid_msg -id 3 -ssname VPL_TCL -severity ERROR "sourcing script ./scripts/_full_opt_post.tcl failed"
    } else {
      send_msg_id runtcl-1 status "$_RESULT"
      send_msg_id runtcl-2 status "sourcing script ./scripts/_full_opt_post.tcl failed"
    }
    return -code error
  }
OPTRACE "Opt Design: post hook" END { }
OPTRACE "opt_design reports" START { REPORT }
OPTRACE "opt_design reports" END { }
  close_msg_db -file opt_design.pb
} RESULT]
if {$rc} {
  step_failed opt_design
  return -code error $RESULT
} else {
  end_step opt_design
  unset ACTIVE_STEP 
}

OPTRACE "Phase: Opt Design" END { }
set end_time [clock seconds]
set total_seconds [expr $end_time - $start_time]
puts $logFileId "opt: $total_seconds seconds"




set start_time [clock seconds]
OPTRACE "Phase: Place Design" START { ROLLUP_AUTO }
start_step place_design
set ACTIVE_STEP place_design
set rc [catch {
  create_msg_db place_design.pb
OPTRACE "Place Design: pre hook" START { }
  set src_rc [catch { 
    puts "source ./scripts/_full_place_pre.tcl"
    source ./scripts/_full_place_pre.tcl
  } _RESULT] 
  if {$src_rc} { 
    set tool_flow [get_property -quiet TOOL_FLOW [current_project -quiet]]
    if { $tool_flow eq {SDx} } { 
      send_gid_msg -id 2 -ssname VPL_TCL -severity ERROR $_RESULT
      send_gid_msg -id 3 -ssname VPL_TCL -severity ERROR "sourcing script ./scripts/_full_place_pre.tcl failed"
    } else {
      send_msg_id runtcl-1 status "$_RESULT"
      send_msg_id runtcl-2 status "sourcing script ./scripts/_full_place_pre.tcl failed"
    }
    return -code error
  }
OPTRACE "Place Design: pre hook" END { }
OPTRACE "read constraints: place_design" START { }
OPTRACE "read constraints: place_design" END { }
  if { [llength [get_debug_cores -quiet] ] > 0 }  { 
OPTRACE "implement_debug_core" START { }
    implement_debug_core 
OPTRACE "implement_debug_core" END { }
  } 
OPTRACE "place_design" START { }
  place_design 
OPTRACE "place_design" END { }
OPTRACE "read constraints: place_design_post" START { }
OPTRACE "read constraints: place_design_post" END { }
OPTRACE "Place Design: post hook" START { }
  set src_rc [catch { 
    puts "source ./scripts/_full_place_post.tcl"
    source ./scripts/_full_place_post.tcl
  } _RESULT] 
  if {$src_rc} { 
    set tool_flow [get_property -quiet TOOL_FLOW [current_project -quiet]]
    if { $tool_flow eq {SDx} } { 
      send_gid_msg -id 2 -ssname VPL_TCL -severity ERROR $_RESULT
      send_gid_msg -id 3 -ssname VPL_TCL -severity ERROR "sourcing script ./scripts/_full_place_post.tcl failed"
    } else {
      send_msg_id runtcl-1 status "$_RESULT"
      send_msg_id runtcl-2 status "sourcing script ./scripts/_full_place_post.tcl failed"
    }
    return -code error
  }
OPTRACE "Place Design: post hook" END { }
OPTRACE "place_design reports" START { REPORT }
OPTRACE "place_design reports" END { }
  close_msg_db -file place_design.pb
} RESULT]
if {$rc} {
  step_failed place_design
  return -code error $RESULT
} else {
  end_step place_design
  unset ACTIVE_STEP 
}

OPTRACE "Phase: Place Design" END { }
set end_time [clock seconds]
set total_seconds [expr $end_time - $start_time]
puts $logFileId "place: $total_seconds seconds"




set start_time [clock seconds]
OPTRACE "Phase: Physical Opt Design" START { ROLLUP_AUTO }
start_step phys_opt_design
set ACTIVE_STEP phys_opt_design
set rc [catch {
  create_msg_db phys_opt_design.pb
OPTRACE "read constraints: phys_opt_design" START { }
OPTRACE "read constraints: phys_opt_design" END { }
OPTRACE "phys_opt_design" START { }
  phys_opt_design 
OPTRACE "phys_opt_design" END { }
OPTRACE "read constraints: phys_opt_design_post" START { }
OPTRACE "read constraints: phys_opt_design_post" END { }
OPTRACE "phys_opt_design report" START { REPORT }
OPTRACE "phys_opt_design report" END { }
  close_msg_db -file phys_opt_design.pb
} RESULT]
if {$rc} {
  step_failed phys_opt_design
  return -code error $RESULT
} else {
  end_step phys_opt_design
  unset ACTIVE_STEP 
}

OPTRACE "Phase: Physical Opt Design" END { }
set end_time [clock seconds]
set total_seconds [expr $end_time - $start_time]
puts $logFileId "opt_physical: $total_seconds seconds"




set start_time [clock seconds]
OPTRACE "Phase: Route Design" START { ROLLUP_AUTO }
start_step route_design
set ACTIVE_STEP route_design
set rc [catch {
  create_msg_db route_design.pb
OPTRACE "read constraints: route_design" START { }
OPTRACE "read constraints: route_design" END { }
OPTRACE "route_design" START { }
  route_design 
OPTRACE "route_design" END { }
OPTRACE "read constraints: route_design_post" START { }
OPTRACE "read constraints: route_design_post" END { }
OPTRACE "Route Design: post hook" START { }
  set src_rc [catch { 
    puts "source ./scripts/_full_route_post.tcl"
    source ./scripts/_full_route_post.tcl
  } _RESULT] 
  if {$src_rc} { 
    set tool_flow [get_property -quiet TOOL_FLOW [current_project -quiet]]
    if { $tool_flow eq {SDx} } { 
      send_gid_msg -id 2 -ssname VPL_TCL -severity ERROR $_RESULT
      send_gid_msg -id 3 -ssname VPL_TCL -severity ERROR "sourcing script ./scripts/_full_route_post.tcl failed"
    } else {
      send_msg_id runtcl-1 status "$_RESULT"
      send_msg_id runtcl-2 status "sourcing script ./scripts/_full_route_post.tcl failed"
    }
    return -code error
  }
OPTRACE "Route Design: post hook" END { }
OPTRACE "Route Design: write_checkpoint" START { CHECKPOINT }
  write_checkpoint -force pfm_top_wrapper_routed.dcp
OPTRACE "Route Design: write_checkpoint" END { }
OPTRACE "route_design reports" START { REPORT }
  create_report "impl_report_timing_summary_route_design_summary" "report_timing_summary -max_paths 10 -file hw_bb_locked_timing_summary_routed.rpt -pb hw_bb_locked_timing_summary_routed.pb -rpx hw_bb_locked_timing_summary_routed.rpx -warn_on_violation "
OPTRACE "route_design reports" END { }
OPTRACE "route_design misc" START { }
  set_property HD.PLATFORM_WRAPPER 1 [get_cells pfm_top_i/dynamic_region]
  close_msg_db -file route_design.pb
OPTRACE "route_design write_checkpoint" START { CHECKPOINT }
OPTRACE "route_design write_checkpoint" END { }
} RESULT]
if {$rc} {
  write_checkpoint -force pfm_top_wrapper_routed_error.dcp
  step_failed route_design
  return -code error $RESULT
} else {
  end_step route_design
  unset ACTIVE_STEP 
}

OPTRACE "route_design misc" END { }
OPTRACE "Phase: Route Design" END { }
set end_time [clock seconds]
set total_seconds [expr $end_time - $start_time]
puts $logFileId "route: $total_seconds seconds"

set start_time [clock seconds]
OPTRACE "Phase: Write Bitstream" START { ROLLUP_AUTO }
  set_property IS_ENABLED 0 [get_drc_checks {PPURQ-1}]
  write_bitstream -cell $inst_name -force $bit_name
OPTRACE "Phase: Write Bitstream" END { }
set end_time [clock seconds]
set total_seconds [expr $end_time - $start_time]
puts $logFileId "bitgen: $total_seconds seconds"
report_timing_summary > timing_${page_name}.rpt

OPTRACE "impl_1" END { }
