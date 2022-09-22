open_checkpoint ./checkpoint/sub_p20_p1/p20_p1_subdivide_route_design.dcp
pr_recombine -cell pfm_top_i/dynamic_region/ydma_1/page12_inst/p0
pr_recombine -cell pfm_top_i/dynamic_region/ydma_1/page12_inst/p1
pr_recombine -cell pfm_top_i/dynamic_region/ydma_1/page12_inst
write_checkpoint -force ./checkpoint/sub_p12/p12_subdivide_recombined.dcp
write_bitstream -force -cell pfm_top_i/dynamic_region/ydma_1/page12_inst ./checkpoint/p12_subdivide.bit
write_abstract_shell -force -cell pfm_top_i/dynamic_region/ydma_1/page12_inst ./checkpoint/p12
report_utilization -pblocks p12 > ./checkpoint/utilization_p12.rpt
# report_utilization > ./checkpoint/abs_analysis/p12.rpt
close_project
