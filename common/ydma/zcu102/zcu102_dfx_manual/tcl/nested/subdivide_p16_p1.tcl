open_checkpoint ./checkpoint/sub_p16_p0/p16_p0_subdivide_route_design.dcp
pr_subdivide -cell pfm_top_i/dynamic_region/ydma_1/page16_inst/p1 -subcells {pfm_top_i/dynamic_region/ydma_1/page16_inst/p1/p0 pfm_top_i/dynamic_region/ydma_1/page16_inst/p1/p1} ./checkpoint/subdivide/page_double_subdivide_p16_p1.dcp
exec mkdir -p ./checkpoint/sub_p16_p1/
write_checkpoint -force ./checkpoint/sub_p16_p1/static_p16_p1.dcp
