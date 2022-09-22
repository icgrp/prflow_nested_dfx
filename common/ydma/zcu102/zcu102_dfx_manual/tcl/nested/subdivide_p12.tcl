open_checkpoint ./checkpoint/sub_p8_p1/p8_p1_subdivide_route_design.dcp     
pr_subdivide -cell pfm_top_i/dynamic_region/ydma_1/page12_inst -subcells {pfm_top_i/dynamic_region/ydma_1/page12_inst/p0 pfm_top_i/dynamic_region/ydma_1/page12_inst/p1} ./checkpoint/subdivide/page_quad_subdivide_p12.dcp
exec mkdir -p ./checkpoint/sub_p12/
write_checkpoint -force ./checkpoint/sub_p12/static_p12.dcp
