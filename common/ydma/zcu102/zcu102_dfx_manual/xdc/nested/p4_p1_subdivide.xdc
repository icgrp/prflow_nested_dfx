create_pblock p4_p1_p0
add_cells_to_pblock [get_pblocks p4_p1_p0] [get_cells -quiet [list pfm_top_i/dynamic_region/ydma_1/page4_inst/p1/p0]]
resize_pblock [get_pblocks p4_p1_p0] -add {SLICE_X63Y120:SLICE_X78Y179 SLICE_X62Y125:SLICE_X62Y179}
resize_pblock [get_pblocks p4_p1_p0] -add {DSP48E2_X13Y48:DSP48E2_X15Y71}
resize_pblock [get_pblocks p4_p1_p0] -add {RAMB18_X8Y48:RAMB18_X9Y71}
resize_pblock [get_pblocks p4_p1_p0] -add {RAMB36_X8Y24:RAMB36_X9Y35}
set_property SNAPPING_MODE ON [get_pblocks p4_p1_p0]
set_property IS_SOFT FALSE [get_pblocks p4_p1_p0]

create_pblock p4_p1_p1
add_cells_to_pblock [get_pblocks p4_p1_p1] [get_cells -quiet [list pfm_top_i/dynamic_region/ydma_1/page4_inst/p1/p1]]
resize_pblock [get_pblocks p4_p1_p1] -add {SLICE_X79Y120:SLICE_X95Y179}
resize_pblock [get_pblocks p4_p1_p1] -add {DSP48E2_X16Y48:DSP48E2_X17Y71}
resize_pblock [get_pblocks p4_p1_p1] -add {RAMB18_X10Y48:RAMB18_X12Y71}
resize_pblock [get_pblocks p4_p1_p1] -add {RAMB36_X10Y24:RAMB36_X12Y35}
set_property SNAPPING_MODE ON [get_pblocks p4_p1_p1]
set_property IS_SOFT FALSE [get_pblocks p4_p1_p1]