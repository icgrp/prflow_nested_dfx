open_checkpoint ./checkpoint/sub_p8/p8_subdivide_route_design.dcp
pr_subdivide -cell pfm_top_i/dynamic_region/ydma_1/page8_inst/p0 -subcells {pfm_top_i/dynamic_region/ydma_1/page8_inst/p0/p0 pfm_top_i/dynamic_region/ydma_1/page8_inst/p0/p1} ./checkpoint/subdivide/page_double_subdivide_p8_p0.dcp
exec mkdir -p ./checkpoint/sub_p8_p0/
write_checkpoint -force ./checkpoint/sub_p8_p0/static_p8_p0.dcp