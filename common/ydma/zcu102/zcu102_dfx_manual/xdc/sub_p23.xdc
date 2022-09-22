create_pblock p2
add_cells_to_pblock [get_pblocks p2] [get_cells -quiet [list pfm_top_i/dynamic_region/ydma_1/page2_inst]]
resize_pblock [get_pblocks p2] -add {SLICE_X62Y0:SLICE_X95Y59}
resize_pblock [get_pblocks p2] -add {DSP48E2_X13Y0:DSP48E2_X17Y23}
resize_pblock [get_pblocks p2] -add {RAMB18_X8Y0:RAMB18_X12Y23}
resize_pblock [get_pblocks p2] -add {RAMB36_X8Y0:RAMB36_X12Y11}
set_property SNAPPING_MODE ON [get_pblocks p2]
set_property IS_SOFT FALSE [get_pblocks p2]

create_pblock p4
add_cells_to_pblock [get_pblocks p4] [get_cells -quiet [list pfm_top_i/dynamic_region/ydma_1/page4_inst]]
resize_pblock [get_pblocks p4] -add {SLICE_X87Y60:SLICE_X95Y179 SLICE_X85Y120:SLICE_X86Y179 SLICE_X62Y60:SLICE_X84Y179}
resize_pblock [get_pblocks p4] -add {DSP48E2_X13Y24:DSP48E2_X17Y71}
resize_pblock [get_pblocks p4] -add {RAMB18_X8Y24:RAMB18_X12Y71}
resize_pblock [get_pblocks p4] -add {RAMB36_X8Y12:RAMB36_X12Y35}
set_property SNAPPING_MODE ON [get_pblocks p4]
set_property IS_SOFT FALSE [get_pblocks p4]

create_pblock p8
add_cells_to_pblock [get_pblocks p8] [get_cells -quiet [list pfm_top_i/dynamic_region/ydma_1/page8_inst]]
resize_pblock [get_pblocks p8] -add {SLICE_X62Y180:SLICE_X95Y299}
resize_pblock [get_pblocks p8] -add {DSP48E2_X13Y72:DSP48E2_X17Y119}
resize_pblock [get_pblocks p8] -add {RAMB18_X8Y72:RAMB18_X12Y119}
resize_pblock [get_pblocks p8] -add {RAMB36_X8Y36:RAMB36_X12Y59}
set_property SNAPPING_MODE ON [get_pblocks p8]
set_property IS_SOFT FALSE [get_pblocks p8]

create_pblock p12
add_cells_to_pblock [get_pblocks p12] [get_cells -quiet [list pfm_top_i/dynamic_region/ydma_1/page12_inst]]
resize_pblock [get_pblocks p12] -add {SLICE_X62Y300:SLICE_X95Y419}
resize_pblock [get_pblocks p12] -add {DSP48E2_X13Y120:DSP48E2_X17Y167}
resize_pblock [get_pblocks p12] -add {RAMB18_X8Y120:RAMB18_X12Y167}
resize_pblock [get_pblocks p12] -add {RAMB36_X8Y60:RAMB36_X12Y83}
set_property SNAPPING_MODE ON [get_pblocks p12]
set_property IS_SOFT FALSE [get_pblocks p12]

create_pblock p16
add_cells_to_pblock [get_pblocks p16] [get_cells -quiet [list pfm_top_i/dynamic_region/ydma_1/page16_inst]]
resize_pblock [get_pblocks p16] -add {SLICE_X29Y300:SLICE_X33Y419}
resize_pblock [get_pblocks p16] -add {RAMB18_X4Y120:RAMB18_X4Y167}
resize_pblock [get_pblocks p16] -add {RAMB36_X4Y60:RAMB36_X4Y83}
resize_pblock [get_pblocks p16] -add {CLOCKREGION_X0Y5:CLOCKREGION_X0Y6}
set_property SNAPPING_MODE ON [get_pblocks p16]
set_property IS_SOFT FALSE [get_pblocks p16]

create_pblock p20
add_cells_to_pblock [get_pblocks p20] [get_cells -quiet [list pfm_top_i/dynamic_region/ydma_1/page20_inst]]
resize_pblock [get_pblocks p20] -add {SLICE_X29Y180:SLICE_X33Y299}
resize_pblock [get_pblocks p20] -add {RAMB18_X4Y72:RAMB18_X4Y119}
resize_pblock [get_pblocks p20] -add {RAMB36_X4Y36:RAMB36_X4Y59}
resize_pblock [get_pblocks p20] -add {CLOCKREGION_X0Y3:CLOCKREGION_X0Y4}
set_property SNAPPING_MODE ON [get_pblocks p20]
set_property IS_SOFT FALSE [get_pblocks p20]

create_pblock p_bft
add_cells_to_pblock [get_pblocks p_bft] [get_cells -quiet [list pfm_top_i/dynamic_region/ydma_1/bft_inst]]
resize_pblock [get_pblocks p_bft] -add {SLICE_X44Y30:SLICE_X52Y389}
resize_pblock [get_pblocks p_bft] -add {DSP48E2_X9Y12:DSP48E2_X10Y155}
resize_pblock [get_pblocks p_bft] -add {RAMB18_X6Y12:RAMB18_X6Y155}
resize_pblock [get_pblocks p_bft] -add {RAMB36_X6Y6:RAMB36_X6Y77}
set_property SNAPPING_MODE ON [get_pblocks p_bft]
set_property IS_SOFT FALSE [get_pblocks p_bft]