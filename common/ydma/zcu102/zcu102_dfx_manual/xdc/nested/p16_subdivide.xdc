create_pblock p16_p0
add_cells_to_pblock [get_pblocks p16_p0] [get_cells -quiet [list pfm_top_i/dynamic_region/ydma_1/page16_inst/p0]]
resize_pblock [get_pblocks p16_p0] -add {SLICE_X29Y360:SLICE_X33Y419}
resize_pblock [get_pblocks p16_p0] -add {RAMB18_X4Y144:RAMB18_X4Y167}
resize_pblock [get_pblocks p16_p0] -add {RAMB36_X4Y72:RAMB36_X4Y83}
resize_pblock [get_pblocks p16_p0] -add {CLOCKREGION_X0Y6:CLOCKREGION_X0Y6}
set_property SNAPPING_MODE ON [get_pblocks p16_p0]
set_property IS_SOFT FALSE [get_pblocks p16_p0]

create_pblock p16_p1
add_cells_to_pblock [get_pblocks p16_p1] [get_cells -quiet [list pfm_top_i/dynamic_region/ydma_1/page16_inst/p1]]
resize_pblock [get_pblocks p16_p1] -add {SLICE_X33Y305:SLICE_X33Y359 SLICE_X29Y300:SLICE_X32Y359}
resize_pblock [get_pblocks p16_p1] -add {RAMB18_X4Y120:RAMB18_X4Y143}
resize_pblock [get_pblocks p16_p1] -add {RAMB36_X4Y60:RAMB36_X4Y71}
resize_pblock [get_pblocks p16_p1] -add {CLOCKREGION_X0Y5:CLOCKREGION_X0Y5}
set_property SNAPPING_MODE ON [get_pblocks p16_p1]
set_property IS_SOFT FALSE [get_pblocks p16_p1]



