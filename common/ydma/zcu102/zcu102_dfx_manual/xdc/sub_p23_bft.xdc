create_pblock p_2
add_cells_to_pblock [get_pblocks p_2] [get_cells -quiet [list pfm_top_i/dynamic_region/ydma_1/page2_inst]]
#resize_pblock [get_pblocks p_2] -add {SLICE_X46Y0:SLICE_X78Y59}
#resize_pblock [get_pblocks p_2] -add {DSP48E2_X9Y0:DSP48E2_X15Y23}
#resize_pblock [get_pblocks p_2] -add {RAMB18_X6Y0:RAMB18_X9Y23}
#resize_pblock [get_pblocks p_2] -add {RAMB36_X6Y0:RAMB36_X9Y11}
resize_pblock [get_pblocks p_2] -add {SLICE_X55Y0:SLICE_X84Y59}
resize_pblock [get_pblocks p_2] -add {DSP48E2_X11Y0:DSP48E2_X15Y23}
resize_pblock [get_pblocks p_2] -add {RAMB18_X7Y0:RAMB18_X11Y23}
resize_pblock [get_pblocks p_2] -add {RAMB36_X7Y0:RAMB36_X11Y11}
set_property SNAPPING_MODE ON [get_pblocks p_2]
set_property IS_SOFT FALSE [get_pblocks p_2]

create_pblock p_4
add_cells_to_pblock [get_pblocks p_4] [get_cells -quiet [list pfm_top_i/dynamic_region/ydma_1/page4_inst]]
resize_pblock [get_pblocks p_4] -add {SLICE_X55Y60:SLICE_X84Y179}
resize_pblock [get_pblocks p_4] -add {DSP48E2_X11Y24:DSP48E2_X15Y71}
resize_pblock [get_pblocks p_4] -add {RAMB18_X7Y24:RAMB18_X11Y71}
resize_pblock [get_pblocks p_4] -add {RAMB36_X7Y12:RAMB36_X11Y35}
#resize_pblock [get_pblocks p_4] -add {SLICE_X46Y60:SLICE_X78Y179}
#resize_pblock [get_pblocks p_4] -add {DSP48E2_X9Y24:DSP48E2_X15Y71}
#resize_pblock [get_pblocks p_4] -add {RAMB18_X6Y24:RAMB18_X9Y71}
#resize_pblock [get_pblocks p_4] -add {RAMB36_X6Y12:RAMB36_X9Y35}
set_property SNAPPING_MODE ON [get_pblocks p_4]
set_property IS_SOFT FALSE [get_pblocks p_4]

create_pblock p_8
add_cells_to_pblock [get_pblocks p_8] [get_cells -quiet [list pfm_top_i/dynamic_region/ydma_1/page8_inst]]
resize_pblock [get_pblocks p_8] -add {SLICE_X29Y180:SLICE_X33Y419}
resize_pblock [get_pblocks p_8] -add {RAMB18_X4Y72:RAMB18_X4Y167}
resize_pblock [get_pblocks p_8] -add {RAMB36_X4Y36:RAMB36_X4Y83}
resize_pblock [get_pblocks p_8] -add {CLOCKREGION_X0Y3:CLOCKREGION_X0Y6}
set_property SNAPPING_MODE ON [get_pblocks p_8]
set_property IS_SOFT FALSE [get_pblocks p_8]

create_pblock p_16
add_cells_to_pblock [get_pblocks p_16] [get_cells -quiet [list pfm_top_i/dynamic_region/ydma_1/page16_inst]]
resize_pblock [get_pblocks p_16] -add {SLICE_X62Y240:SLICE_X95Y419 SLICE_X46Y300:SLICE_X61Y419}
resize_pblock [get_pblocks p_16] -add {DSP48E2_X13Y96:DSP48E2_X17Y167 DSP48E2_X9Y120:DSP48E2_X12Y167}
resize_pblock [get_pblocks p_16] -add {RAMB18_X8Y96:RAMB18_X12Y167 RAMB18_X6Y120:RAMB18_X7Y167}
resize_pblock [get_pblocks p_16] -add {RAMB36_X8Y48:RAMB36_X12Y83 RAMB36_X6Y60:RAMB36_X7Y83}
set_property SNAPPING_MODE ON [get_pblocks p_16]
set_property IS_SOFT FALSE [get_pblocks p_16]


create_pblock p_bft
add_cells_to_pblock [get_pblocks p_bft] [get_cells -quiet [list pfm_top_i/dynamic_region/ydma_1/bft_inst]]
#resize_pblock [get_pblocks p_bft] -add {SLICE_X46Y180:SLICE_X54Y299 SLICE_X34Y180:SLICE_X45Y359}
#resize_pblock [get_pblocks p_bft] -add {DSP48E2_X9Y72:DSP48E2_X10Y119 DSP48E2_X6Y72:DSP48E2_X8Y143}
#resize_pblock [get_pblocks p_bft] -add {RAMB18_X6Y72:RAMB18_X6Y119 RAMB18_X5Y72:RAMB18_X5Y143}
#resize_pblock [get_pblocks p_bft] -add {RAMB36_X6Y36:RAMB36_X6Y59 RAMB36_X5Y36:RAMB36_X5Y71}
#resize_pblock [get_pblocks p_bft] -add {SLICE_X46Y180:SLICE_X51Y299 SLICE_X34Y180:SLICE_X45Y359}
#resize_pblock [get_pblocks p_bft] -add {DSP48E2_X9Y72:DSP48E2_X9Y119 DSP48E2_X6Y72:DSP48E2_X8Y143}
#resize_pblock [get_pblocks p_bft] -add {RAMB18_X6Y72:RAMB18_X6Y119 RAMB18_X5Y72:RAMB18_X5Y143}
#resize_pblock [get_pblocks p_bft] -add {RAMB36_X6Y36:RAMB36_X6Y59 RAMB36_X5Y36:RAMB36_X5Y71}

resize_pblock [get_pblocks p_bft] -add {SLICE_X46Y180:SLICE_X48Y299 SLICE_X34Y180:SLICE_X45Y419}
resize_pblock [get_pblocks p_bft] -add {DSP48E2_X6Y72:DSP48E2_X8Y167}
resize_pblock [get_pblocks p_bft] -add {RAMB18_X6Y72:RAMB18_X6Y119 RAMB18_X5Y72:RAMB18_X5Y167}
resize_pblock [get_pblocks p_bft] -add {RAMB36_X6Y36:RAMB36_X6Y59 RAMB36_X5Y36:RAMB36_X5Y83}
set_property SNAPPING_MODE ON [get_pblocks p_bft]
set_property IS_SOFT FALSE [get_pblocks p_bft]
