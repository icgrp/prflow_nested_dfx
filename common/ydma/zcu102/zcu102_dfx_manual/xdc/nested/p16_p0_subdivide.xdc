create_pblock p16_p0_p0
add_cells_to_pblock [get_pblocks p16_p0_p0] [get_cells -quiet [list pfm_top_i/dynamic_region/ydma_1/page16_inst/p0/p0]]
resize_pblock [get_pblocks p16_p0_p0] -add {SLICE_X33Y365:SLICE_X33Y419 SLICE_X16Y360:SLICE_X32Y419}
resize_pblock [get_pblocks p16_p0_p0] -add {DSP48E2_X3Y144:DSP48E2_X5Y167}
resize_pblock [get_pblocks p16_p0_p0] -add {RAMB18_X2Y144:RAMB18_X4Y167}
resize_pblock [get_pblocks p16_p0_p0] -add {RAMB36_X2Y72:RAMB36_X4Y83}
set_property SNAPPING_MODE ON [get_pblocks p16_p0_p0]
set_property IS_SOFT FALSE [get_pblocks p16_p0_p0]

create_pblock p16_p0_p1
add_cells_to_pblock [get_pblocks p16_p0_p1] [get_cells -quiet [list pfm_top_i/dynamic_region/ydma_1/page16_inst/p0/p1]]
resize_pblock [get_pblocks p16_p0_p1] -add {SLICE_X0Y360:SLICE_X15Y419}
resize_pblock [get_pblocks p16_p0_p1] -add {DSP48E2_X0Y144:DSP48E2_X2Y167}
resize_pblock [get_pblocks p16_p0_p1] -add {RAMB18_X0Y144:RAMB18_X1Y167}
resize_pblock [get_pblocks p16_p0_p1] -add {RAMB36_X0Y72:RAMB36_X1Y83}
set_property SNAPPING_MODE ON [get_pblocks p16_p0_p1]
set_property IS_SOFT FALSE [get_pblocks p16_p0_p1]


