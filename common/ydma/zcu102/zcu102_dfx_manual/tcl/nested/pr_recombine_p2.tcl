open_checkpoint ./checkpoint/sub_p20_p1/p20_p1_subdivide_route_design.dcp
pr_recombine -cell pfm_top_i/dynamic_region/ydma_1/page2_inst
write_checkpoint -force ./checkpoint/sub_p2/p2_subdivide_recombined.dcp
write_bitstream -force -cell pfm_top_i/dynamic_region/ydma_1/page2_inst ./checkpoint/p2_subdivide.bit
write_abstract_shell -force -cell pfm_top_i/dynamic_region/ydma_1/page2_inst ./checkpoint/p2
report_utilization -pblocks p2 > ./checkpoint/utilization_p2.rpt
# report_utilization > ./checkpoint/abs_analysis/p2.rpt
close_project
