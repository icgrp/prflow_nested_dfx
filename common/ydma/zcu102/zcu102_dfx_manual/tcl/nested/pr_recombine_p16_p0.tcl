open_checkpoint ./checkpoint/sub_p20_p1/p20_p1_subdivide_route_design.dcp
pr_recombine -cell pfm_top_i/dynamic_region/ydma_1/page16_inst/p0
write_checkpoint -force ./checkpoint/sub_p16_p0/p16_p0_subdivide_recombined.dcp
write_bitstream -force -cell pfm_top_i/dynamic_region/ydma_1/page16_inst/p0 ./checkpoint/p16_p0_subdivide.bit
write_abstract_shell -force -cell pfm_top_i/dynamic_region/ydma_1/page16_inst/p0 ./checkpoint/p16_p0
report_utilization -pblocks p16_p0 > ./checkpoint/utilization_p16_p0.rpt
# report_utilization > ./checkpoint/abs_analysis/p16_p0.rpt
close_project