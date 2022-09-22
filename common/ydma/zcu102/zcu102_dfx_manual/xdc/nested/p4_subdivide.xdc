create_pblock p4_p0
add_cells_to_pblock [get_pblocks p4_p0] [get_cells -quiet [list pfm_top_i/dynamic_region/ydma_1/page4_inst/p0]]
resize_pblock [get_pblocks p4_p0] -add {SLICE_X87Y60:SLICE_X95Y119 SLICE_X63Y60:SLICE_X84Y119 SLICE_X62Y65:SLICE_X62Y119}
resize_pblock [get_pblocks p4_p0] -add {DSP48E2_X13Y24:DSP48E2_X17Y47}
resize_pblock [get_pblocks p4_p0] -add {RAMB18_X8Y24:RAMB18_X12Y47}
resize_pblock [get_pblocks p4_p0] -add {RAMB36_X8Y12:RAMB36_X12Y23}
set_property SNAPPING_MODE ON [get_pblocks p4_p0]
set_property IS_SOFT FALSE [get_pblocks p4_p0]

create_pblock p4_p1
add_cells_to_pblock [get_pblocks p4_p1] [get_cells -quiet [list pfm_top_i/dynamic_region/ydma_1/page4_inst/p1]]
resize_pblock [get_pblocks p4_p1] -add {SLICE_X62Y120:SLICE_X95Y179}
resize_pblock [get_pblocks p4_p1] -add {DSP48E2_X13Y48:DSP48E2_X17Y71}
resize_pblock [get_pblocks p4_p1] -add {RAMB18_X8Y48:RAMB18_X12Y71}
resize_pblock [get_pblocks p4_p1] -add {RAMB36_X8Y24:RAMB36_X12Y35}
set_property SNAPPING_MODE ON [get_pblocks p4_p1]
set_property IS_SOFT FALSE [get_pblocks p4_p1]