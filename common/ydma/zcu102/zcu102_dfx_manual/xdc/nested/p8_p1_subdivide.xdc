create_pblock p8_p1_p0
add_cells_to_pblock [get_pblocks p8_p1_p0] [get_cells -quiet [list pfm_top_i/dynamic_region/ydma_1/page8_inst/p1/p0]]
resize_pblock [get_pblocks p8_p1_p0] -add {SLICE_X63Y240:SLICE_X78Y299 SLICE_X62Y250:SLICE_X62Y299}
resize_pblock [get_pblocks p8_p1_p0] -add {DSP48E2_X13Y96:DSP48E2_X15Y119}
resize_pblock [get_pblocks p8_p1_p0] -add {RAMB18_X8Y96:RAMB18_X9Y119}
resize_pblock [get_pblocks p8_p1_p0] -add {RAMB36_X8Y48:RAMB36_X9Y59}
set_property SNAPPING_MODE ON [get_pblocks p8_p1_p0]
set_property IS_SOFT FALSE [get_pblocks p8_p1_p0]

create_pblock p8_p1_p1
add_cells_to_pblock [get_pblocks p8_p1_p1] [get_cells -quiet [list pfm_top_i/dynamic_region/ydma_1/page8_inst/p1/p1]]
resize_pblock [get_pblocks p8_p1_p1] -add {SLICE_X79Y240:SLICE_X95Y299}
resize_pblock [get_pblocks p8_p1_p1] -add {DSP48E2_X16Y96:DSP48E2_X17Y119}
resize_pblock [get_pblocks p8_p1_p1] -add {RAMB18_X10Y96:RAMB18_X12Y119}
resize_pblock [get_pblocks p8_p1_p1] -add {RAMB36_X10Y48:RAMB36_X12Y59}
set_property SNAPPING_MODE ON [get_pblocks p8_p1_p1]
set_property IS_SOFT FALSE [get_pblocks p8_p1_p1]
