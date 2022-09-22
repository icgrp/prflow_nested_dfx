open_checkpoint ./checkpoint/sub_p20_p1/p20_p1_subdivide_route_design.dcp
pr_recombine -cell pfm_top_i/dynamic_region/ydma_1/page8_inst/p1
write_checkpoint -force ./checkpoint/sub_p8_p1/p8_p1_subdivide_recombined.dcp
write_bitstream -force -cell pfm_top_i/dynamic_region/ydma_1/page8_inst/p1 ./checkpoint/p8_p1_subdivide.bit
write_abstract_shell -force -cell pfm_top_i/dynamic_region/ydma_1/page8_inst/p1 ./checkpoint/p8_p1
report_utilization -pblocks p8_p1 > ./checkpoint/utilization_p8_p1.rpt
# report_utilization > ./checkpoint/abs_analysis/p8_p1.rpt
close_project