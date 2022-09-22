create_pblock p20_p0
add_cells_to_pblock [get_pblocks p20_p0] [get_cells -quiet [list pfm_top_i/dynamic_region/ydma_1/page20_inst/p0]]
resize_pblock [get_pblocks p20_p0] -add {SLICE_X29Y240:SLICE_X33Y299}
resize_pblock [get_pblocks p20_p0] -add {RAMB18_X4Y96:RAMB18_X4Y119}
resize_pblock [get_pblocks p20_p0] -add {RAMB36_X4Y48:RAMB36_X4Y59}
resize_pblock [get_pblocks p20_p0] -add {CLOCKREGION_X0Y4:CLOCKREGION_X0Y4}
set_property SNAPPING_MODE ON [get_pblocks p20_p0]
set_property IS_SOFT FALSE [get_pblocks p20_p0]

create_pblock p20_p1
add_cells_to_pblock [get_pblocks p20_p1] [get_cells -quiet [list pfm_top_i/dynamic_region/ydma_1/page20_inst/p1]]
resize_pblock [get_pblocks p20_p1] -add {SLICE_X33Y185:SLICE_X33Y239 SLICE_X29Y180:SLICE_X32Y239}
resize_pblock [get_pblocks p20_p1] -add {RAMB18_X4Y72:RAMB18_X4Y95}
resize_pblock [get_pblocks p20_p1] -add {RAMB36_X4Y36:RAMB36_X4Y47}
resize_pblock [get_pblocks p20_p1] -add {CLOCKREGION_X0Y3:CLOCKREGION_X0Y3}
set_property SNAPPING_MODE ON [get_pblocks p20_p1]
set_property IS_SOFT FALSE [get_pblocks p20_p1]