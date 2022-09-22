open_checkpoint ./checkpoint/sub_p20_p1/p20_p1_subdivide_route_design.dcp
pr_recombine -cell pfm_top_i/dynamic_region/ydma_1/page16_inst/p0
pr_recombine -cell pfm_top_i/dynamic_region/ydma_1/page16_inst/p1
pr_recombine -cell pfm_top_i/dynamic_region/ydma_1/page16_inst
write_checkpoint -force ./checkpoint/sub_p16/p16_subdivide_recombined.dcp
write_bitstream -force -cell pfm_top_i/dynamic_region/ydma_1/page16_inst ./checkpoint/p16_subdivide.bit
write_abstract_shell -force -cell pfm_top_i/dynamic_region/ydma_1/page16_inst ./checkpoint/p16
report_utilization -pblocks p16 > ./checkpoint/utilization_p16.rpt
# report_utilization > ./checkpoint/abs_analysis/p16.rpt
close_project
