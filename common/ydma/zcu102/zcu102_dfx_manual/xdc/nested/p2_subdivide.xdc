create_pblock p2_p0
add_cells_to_pblock [get_pblocks p2_p0] [get_cells -quiet [list pfm_top_i/dynamic_region/ydma_1/page2_inst/p0]]
resize_pblock [get_pblocks p2_p0] -add {SLICE_X63Y0:SLICE_X78Y59 SLICE_X62Y5:SLICE_X62Y59}
resize_pblock [get_pblocks p2_p0] -add {DSP48E2_X13Y0:DSP48E2_X15Y23}
resize_pblock [get_pblocks p2_p0] -add {RAMB18_X8Y0:RAMB18_X9Y23}
resize_pblock [get_pblocks p2_p0] -add {RAMB36_X8Y0:RAMB36_X9Y11}
set_property SNAPPING_MODE ON [get_pblocks p2_p0]
set_property IS_SOFT FALSE [get_pblocks p2_p0]


create_pblock p2_p1
add_cells_to_pblock [get_pblocks p2_p1] [get_cells -quiet [list pfm_top_i/dynamic_region/ydma_1/page2_inst/p1]]
resize_pblock [get_pblocks p2_p1] -add {SLICE_X79Y0:SLICE_X95Y59}
resize_pblock [get_pblocks p2_p1] -add {DSP48E2_X16Y0:DSP48E2_X17Y23}
resize_pblock [get_pblocks p2_p1] -add {RAMB18_X10Y0:RAMB18_X12Y23}
resize_pblock [get_pblocks p2_p1] -add {RAMB36_X10Y0:RAMB36_X12Y11}
set_property SNAPPING_MODE ON [get_pblocks p2_p1]
set_property IS_SOFT FALSE [get_pblocks p2_p1]
