open_checkpoint ./checkpoint/sub_p16_p1/p16_p1_subdivide_route_design.dcp  
pr_subdivide -cell pfm_top_i/dynamic_region/ydma_1/page20_inst -subcells {pfm_top_i/dynamic_region/ydma_1/page20_inst/p0 pfm_top_i/dynamic_region/ydma_1/page20_inst/p1} ./checkpoint/subdivide/page_quad_subdivide_p20.dcp
exec mkdir -p ./checkpoint/sub_p20/
write_checkpoint -force ./checkpoint/sub_p20/static_p20.dcp
