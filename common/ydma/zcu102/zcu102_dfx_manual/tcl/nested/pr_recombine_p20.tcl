open_checkpoint ./checkpoint/sub_p20_p1/p20_p1_subdivide_route_design.dcp
pr_recombine -cell pfm_top_i/dynamic_region/ydma_1/page20_inst/p0
pr_recombine -cell pfm_top_i/dynamic_region/ydma_1/page20_inst/p1
pr_recombine -cell pfm_top_i/dynamic_region/ydma_1/page20_inst
write_checkpoint -force ./checkpoint/sub_p20/p20_subdivide_recombined.dcp
write_bitstream -force -cell pfm_top_i/dynamic_region/ydma_1/page20_inst ./checkpoint/p20_subdivide.bit
write_abstract_shell -force -cell pfm_top_i/dynamic_region/ydma_1/page20_inst ./checkpoint/p20
report_utilization -pblocks p20 > ./checkpoint/utilization_p20.rpt
# report_utilization > ./checkpoint/abs_analysis/p20.rpt
close_project
