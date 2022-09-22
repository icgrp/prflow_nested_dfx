create_pblock p4_p0_p0
add_cells_to_pblock [get_pblocks p4_p0_p0] [get_cells -quiet [list pfm_top_i/dynamic_region/ydma_1/page4_inst/p0/p0]]
resize_pblock [get_pblocks p4_p0_p0] -add {SLICE_X63Y60:SLICE_X78Y119 SLICE_X62Y70:SLICE_X62Y119}
resize_pblock [get_pblocks p4_p0_p0] -add {DSP48E2_X13Y24:DSP48E2_X15Y47}
resize_pblock [get_pblocks p4_p0_p0] -add {RAMB18_X8Y24:RAMB18_X9Y47}
resize_pblock [get_pblocks p4_p0_p0] -add {RAMB36_X8Y12:RAMB36_X9Y23}
set_property SNAPPING_MODE ON [get_pblocks p4_p0_p0]
set_property IS_SOFT FALSE [get_pblocks p4_p0_p0]

create_pblock p4_p0_p1
add_cells_to_pblock [get_pblocks p4_p0_p1] [get_cells -quiet [list pfm_top_i/dynamic_region/ydma_1/page4_inst/p0/p1]]
resize_pblock [get_pblocks p4_p0_p1] -add {SLICE_X87Y60:SLICE_X95Y119 SLICE_X79Y60:SLICE_X84Y119}
resize_pblock [get_pblocks p4_p0_p1] -add {DSP48E2_X16Y24:DSP48E2_X17Y47}
resize_pblock [get_pblocks p4_p0_p1] -add {RAMB18_X10Y24:RAMB18_X12Y47}
resize_pblock [get_pblocks p4_p0_p1] -add {RAMB36_X10Y12:RAMB36_X12Y23}
set_property SNAPPING_MODE ON [get_pblocks p4_p0_p1]
set_property IS_SOFT FALSE [get_pblocks p4_p0_p1]