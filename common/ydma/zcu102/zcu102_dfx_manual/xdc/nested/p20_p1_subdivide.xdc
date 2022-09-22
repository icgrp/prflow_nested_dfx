create_pblock p20_p1_p0
add_cells_to_pblock [get_pblocks p20_p1_p0] [get_cells -quiet [list pfm_top_i/dynamic_region/ydma_1/page20_inst/p1/p0]]
resize_pblock [get_pblocks p20_p1_p0] -add {SLICE_X33Y190:SLICE_X33Y239 SLICE_X16Y180:SLICE_X32Y239}
resize_pblock [get_pblocks p20_p1_p0] -add {DSP48E2_X3Y72:DSP48E2_X5Y95}
resize_pblock [get_pblocks p20_p1_p0] -add {RAMB18_X2Y72:RAMB18_X4Y95}
resize_pblock [get_pblocks p20_p1_p0] -add {RAMB36_X2Y36:RAMB36_X4Y47}
set_property SNAPPING_MODE ON [get_pblocks p20_p1_p0]
set_property IS_SOFT FALSE [get_pblocks p20_p1_p0]

create_pblock p20_p1_p1
add_cells_to_pblock [get_pblocks p20_p1_p1] [get_cells -quiet [list pfm_top_i/dynamic_region/ydma_1/page20_inst/p1/p1]]
resize_pblock [get_pblocks p20_p1_p1] -add {SLICE_X0Y180:SLICE_X15Y239}
resize_pblock [get_pblocks p20_p1_p1] -add {DSP48E2_X0Y72:DSP48E2_X2Y95}
resize_pblock [get_pblocks p20_p1_p1] -add {RAMB18_X0Y72:RAMB18_X1Y95}
resize_pblock [get_pblocks p20_p1_p1] -add {RAMB36_X0Y36:RAMB36_X1Y47}
set_property SNAPPING_MODE ON [get_pblocks p20_p1_p1]
set_property IS_SOFT FALSE [get_pblocks p20_p1_p1]


