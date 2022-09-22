create_pblock p12_p1_p0
add_cells_to_pblock [get_pblocks p12_p1_p0] [get_cells -quiet [list pfm_top_i/dynamic_region/ydma_1/page12_inst/p1/p0]]
resize_pblock [get_pblocks p12_p1_p0] -add {SLICE_X63Y360:SLICE_X78Y419 SLICE_X62Y370:SLICE_X62Y419}
resize_pblock [get_pblocks p12_p1_p0] -add {DSP48E2_X13Y144:DSP48E2_X15Y167}
resize_pblock [get_pblocks p12_p1_p0] -add {RAMB18_X8Y144:RAMB18_X9Y167}
resize_pblock [get_pblocks p12_p1_p0] -add {RAMB36_X8Y72:RAMB36_X9Y83}
set_property SNAPPING_MODE ON [get_pblocks p12_p1_p0]
set_property IS_SOFT FALSE [get_pblocks p12_p1_p0]

create_pblock p12_p1_p1
add_cells_to_pblock [get_pblocks p12_p1_p1] [get_cells -quiet [list pfm_top_i/dynamic_region/ydma_1/page12_inst/p1/p1]]
resize_pblock [get_pblocks p12_p1_p1] -add {SLICE_X79Y360:SLICE_X95Y419}
resize_pblock [get_pblocks p12_p1_p1] -add {DSP48E2_X16Y144:DSP48E2_X17Y167}
resize_pblock [get_pblocks p12_p1_p1] -add {RAMB18_X10Y144:RAMB18_X12Y167}
resize_pblock [get_pblocks p12_p1_p1] -add {RAMB36_X10Y72:RAMB36_X12Y83}
set_property SNAPPING_MODE ON [get_pblocks p12_p1_p1]
set_property IS_SOFT FALSE [get_pblocks p12_p1_p1]
