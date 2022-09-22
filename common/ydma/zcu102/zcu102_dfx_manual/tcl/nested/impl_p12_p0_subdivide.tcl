create_project -in_memory -part xczu9eg-ffvb1156-2-e
add_files ./checkpoint/sub_p12_p0/static_p12_p0.dcp
add_files ./checkpoint/page.dcp
set_property SCOPED_TO_CELLS { pfm_top_i/dynamic_region/ydma_1/page12_inst/p0/p0 pfm_top_i/dynamic_region/ydma_1/page12_inst/p0/p1} [get_files ./checkpoint/page.dcp]
add_files ./xdc/nested/p12_p0_subdivide.xdc
set_property USED_IN {implementation} [get_files ./xdc/nested/p12_p0_subdivide.xdc]
set_property PROCESSING_ORDER LATE [get_files ./xdc/nested/p12_p0_subdivide.xdc]
link_design -mode default -reconfig_partitions {pfm_top_i/dynamic_region/ydma_1/page12_inst/p0/p0 pfm_top_i/dynamic_region/ydma_1/page12_inst/p0/p1} -part xczu9eg-ffvb1156-2-e -top pfm_top_wrapper
# write_checkpoint -force ./checkpoint/sub_p12_p0/p12_p0_subdivide_link_design.dcp
opt_design
# write_checkpoint -force ./checkpoint/sub_p12_p0/p12_p0_subdivide_opt_design.dcp
place_design
# write_checkpoint -force ./checkpoint/sub_p12_p0/p12_p0_subdivide_place_design.dcp
phys_opt_design
# write_checkpoint -force ./checkpoint/sub_p12_p0/p12_p0_subdivide_phy_opt_design.dcp
route_design
write_checkpoint -force ./checkpoint/sub_p12_p0/p12_p0_subdivide_route_design.dcp

# update_design -black_box -cell pfm_top_i/dynamic_region/ydma_1/page12_inst/p0/p0
# update_design -black_box -cell pfm_top_i/dynamic_region/ydma_1/page12_inst/p0/p1
# lock_design -level routing
# write_checkpoint -force ./checkpoint/sub_p12_p0/p12_p0_subdivide_static.dcp
# close_project

# open_checkpoint ./checkpoint/sub_p12_p0/p12_p0_subdivide_route_design.dcp
# pr_recombine -cell pfm_top_i/dynamic_region/ydma_1/page12_inst/p0
# write_checkpoint -force ./checkpoint/sub_p12_p0/p12_p0_subdivide_recombined.dcp
# write_bitstream -force -cell pfm_top_i/dynamic_region/ydma_1/page12_inst/p0 ./checkpoint/p12_p0_subdivide.bit
# close_project

# open_checkpoint ./checkpoint/sub_p12_p0/p12_p0_subdivide_route_design.dcp
# update_design -cell pfm_top_i/dynamic_region/ydma_1/page12_inst/p0/p0 -black_box
# lock_design -level routing
# write_abstract_shell -force -cell pfm_top_i/dynamic_region/ydma_1/page12_inst/p0/p0 ./checkpoint/p12_p0_p0
# close_project

# open_checkpoint ./checkpoint/sub_p12_p0/p12_p0_subdivide_route_design.dcp
# update_design -cell pfm_top_i/dynamic_region/ydma_1/page12_inst/p0/p1 -black_box
# lock_design -level routing
# write_abstract_shell -force -cell pfm_top_i/dynamic_region/ydma_1/page12_inst/p0/p1 ./checkpoint/p12_p0_p1
# close_project