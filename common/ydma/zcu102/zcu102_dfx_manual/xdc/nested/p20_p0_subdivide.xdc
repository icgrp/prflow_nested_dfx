create_pblock p20_p0_p0
add_cells_to_pblock [get_pblocks p20_p0_p0] [get_cells -quiet [list pfm_top_i/dynamic_region/ydma_1/page20_inst/p0/p0]]
resize_pblock [get_pblocks p20_p0_p0] -add {SLICE_X33Y245:SLICE_X33Y299 SLICE_X16Y240:SLICE_X32Y299}
resize_pblock [get_pblocks p20_p0_p0] -add {DSP48E2_X3Y96:DSP48E2_X5Y119}
resize_pblock [get_pblocks p20_p0_p0] -add {RAMB18_X2Y96:RAMB18_X4Y119}
resize_pblock [get_pblocks p20_p0_p0] -add {RAMB36_X2Y48:RAMB36_X4Y59}
set_property SNAPPING_MODE ON [get_pblocks p20_p0_p0]
set_property IS_SOFT FALSE [get_pblocks p20_p0_p0]

create_pblock p20_p0_p1
add_cells_to_pblock [get_pblocks p20_p0_p1] [get_cells -quiet [list pfm_top_i/dynamic_region/ydma_1/page20_inst/p0/p1]]
resize_pblock [get_pblocks p20_p0_p1] -add {SLICE_X0Y240:SLICE_X15Y299}
resize_pblock [get_pblocks p20_p0_p1] -add {DSP48E2_X0Y96:DSP48E2_X2Y119}
resize_pblock [get_pblocks p20_p0_p1] -add {RAMB18_X0Y96:RAMB18_X1Y119}
resize_pblock [get_pblocks p20_p0_p1] -add {RAMB36_X0Y48:RAMB36_X1Y59}
set_property SNAPPING_MODE ON [get_pblocks p20_p0_p1]
set_property IS_SOFT FALSE [get_pblocks p20_p0_p1]


