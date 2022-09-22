create_pblock p16_p1_p0
add_cells_to_pblock [get_pblocks p16_p1_p0] [get_cells -quiet [list pfm_top_i/dynamic_region/ydma_1/page16_inst/p1/p0]]
resize_pblock [get_pblocks p16_p1_p0] -add {SLICE_X33Y310:SLICE_X33Y359 SLICE_X16Y300:SLICE_X32Y359}
resize_pblock [get_pblocks p16_p1_p0] -add {DSP48E2_X3Y120:DSP48E2_X5Y143}
resize_pblock [get_pblocks p16_p1_p0] -add {RAMB18_X2Y120:RAMB18_X4Y143}
resize_pblock [get_pblocks p16_p1_p0] -add {RAMB36_X2Y60:RAMB36_X4Y71}
set_property SNAPPING_MODE ON [get_pblocks p16_p1_p0]
set_property IS_SOFT FALSE [get_pblocks p16_p1_p0]


create_pblock p16_p1_p1
add_cells_to_pblock [get_pblocks p16_p1_p1] [get_cells -quiet [list pfm_top_i/dynamic_region/ydma_1/page16_inst/p1/p1]]
resize_pblock [get_pblocks p16_p1_p1] -add {SLICE_X0Y300:SLICE_X15Y359}
resize_pblock [get_pblocks p16_p1_p1] -add {DSP48E2_X0Y120:DSP48E2_X2Y143}
resize_pblock [get_pblocks p16_p1_p1] -add {RAMB18_X0Y120:RAMB18_X1Y143}
resize_pblock [get_pblocks p16_p1_p1] -add {RAMB36_X0Y60:RAMB36_X1Y71}
set_property SNAPPING_MODE ON [get_pblocks p16_p1_p1]
set_property IS_SOFT FALSE [get_pblocks p16_p1_p1]


