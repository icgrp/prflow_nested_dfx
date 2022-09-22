open_checkpoint ./checkpoint/sub_p12_p1/p12_p1_subdivide_route_design.dcp    
pr_subdivide -cell pfm_top_i/dynamic_region/ydma_1/page16_inst -subcells {pfm_top_i/dynamic_region/ydma_1/page16_inst/p0 pfm_top_i/dynamic_region/ydma_1/page16_inst/p1} ./checkpoint/subdivide/page_quad_subdivide_p16.dcp
exec mkdir -p ./checkpoint/sub_p16/
write_checkpoint -force ./checkpoint/sub_p16/static_p16.dcp
