open_checkpoint ./checkpoint/overlay.dcp             
pr_subdivide -cell pfm_top_i/dynamic_region/ydma_1/page2_inst -subcells {pfm_top_i/dynamic_region/ydma_1/page2_inst/p0 pfm_top_i/dynamic_region/ydma_1/page2_inst/p1} ./checkpoint/subdivide/page_double_subdivide_p2.dcp
exec mkdir -p ./checkpoint/sub_p2/
write_checkpoint -force ./checkpoint/sub_p2/static_p2.dcp
