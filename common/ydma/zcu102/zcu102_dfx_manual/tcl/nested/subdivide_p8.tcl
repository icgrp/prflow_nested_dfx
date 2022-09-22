open_checkpoint ./checkpoint/sub_p4_p1/p4_p1_subdivide_route_design.dcp       
pr_subdivide -cell pfm_top_i/dynamic_region/ydma_1/page8_inst -subcells {pfm_top_i/dynamic_region/ydma_1/page8_inst/p0 pfm_top_i/dynamic_region/ydma_1/page8_inst/p1} ./checkpoint/subdivide/page_quad_subdivide_p8.dcp
exec mkdir -p ./checkpoint/sub_p8/
write_checkpoint -force ./checkpoint/sub_p8/static_p8.dcp
