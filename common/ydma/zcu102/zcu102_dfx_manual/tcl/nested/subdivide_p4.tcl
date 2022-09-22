open_checkpoint ./checkpoint/sub_p2/p2_subdivide_route_design.dcp        
pr_subdivide -cell pfm_top_i/dynamic_region/ydma_1/page4_inst -subcells {pfm_top_i/dynamic_region/ydma_1/page4_inst/p0 pfm_top_i/dynamic_region/ydma_1/page4_inst/p1} ./checkpoint/subdivide/page_quad_subdivide_p4.dcp
exec mkdir -p ./checkpoint/sub_p4/
write_checkpoint -force ./checkpoint/sub_p4/static_p4.dcp
