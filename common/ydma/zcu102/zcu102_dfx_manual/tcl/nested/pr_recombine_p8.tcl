open_checkpoint ./checkpoint/sub_p20_p1/p20_p1_subdivide_route_design.dcp
pr_recombine -cell pfm_top_i/dynamic_region/ydma_1/page8_inst/p0
pr_recombine -cell pfm_top_i/dynamic_region/ydma_1/page8_inst/p1
pr_recombine -cell pfm_top_i/dynamic_region/ydma_1/page8_inst
write_checkpoint -force ./checkpoint/sub_p8/p8_subdivide_recombined.dcp
write_bitstream -force -cell pfm_top_i/dynamic_region/ydma_1/page8_inst ./checkpoint/p8_subdivide.bit
write_abstract_shell -force -cell pfm_top_i/dynamic_region/ydma_1/page8_inst ./checkpoint/p8
report_utilization -pblocks p8 > ./checkpoint/utilization_p8.rpt
# report_utilization > ./checkpoint/abs_analysis/p8.rpt
close_project
