create_pblock p_2
add_cells_to_pblock [get_pblocks p_2] [get_cells -quiet [list pfm_top_i/dynamic_region/ydma_1/page2_inst]]
resize_pblock [get_pblocks p_2] -add {SLICE_X64Y0:SLICE_X95Y59}
resize_pblock [get_pblocks p_2] -add {DSP48E2_X13Y0:DSP48E2_X17Y23}
resize_pblock [get_pblocks p_2] -add {IOB_X0Y0:IOB_X0Y37}
resize_pblock [get_pblocks p_2] -add {RAMB18_X8Y0:RAMB18_X12Y23}
resize_pblock [get_pblocks p_2] -add {RAMB36_X8Y0:RAMB36_X12Y11}
set_property SNAPPING_MODE ON [get_pblocks p_2]
set_property IS_SOFT FALSE [get_pblocks p_2]

create_pblock p_3
add_cells_to_pblock [get_pblocks p_3] [get_cells -quiet [list pfm_top_i/dynamic_region/ydma_1/page3_inst]]
resize_pblock [get_pblocks p_3] -add {SLICE_X64Y120:SLICE_X95Y179}
resize_pblock [get_pblocks p_3] -add {CFGIO_SITE_X0Y0:CFGIO_SITE_X0Y0}
resize_pblock [get_pblocks p_3] -add {DSP48E2_X13Y48:DSP48E2_X17Y71}
resize_pblock [get_pblocks p_3] -add {RAMB18_X8Y48:RAMB18_X12Y71}
resize_pblock [get_pblocks p_3] -add {RAMB36_X8Y24:RAMB36_X12Y35}
resize_pblock [get_pblocks p_3] -add {SYSMONE4_X0Y0:SYSMONE4_X0Y0}
set_property SNAPPING_MODE ON [get_pblocks p_3]
set_property IS_SOFT FALSE [get_pblocks p_3]

create_pblock p_4
add_cells_to_pblock [get_pblocks p_4] [get_cells -quiet [list pfm_top_i/dynamic_region/ydma_1/page4_inst]]
resize_pblock [get_pblocks p_4] -add {SLICE_X64Y180:SLICE_X95Y239}
resize_pblock [get_pblocks p_4] -add {DSP48E2_X13Y72:DSP48E2_X17Y95}
resize_pblock [get_pblocks p_4] -add {IOB_X0Y156:IOB_X0Y193}
resize_pblock [get_pblocks p_4] -add {RAMB18_X8Y72:RAMB18_X12Y95}
resize_pblock [get_pblocks p_4] -add {RAMB36_X8Y36:RAMB36_X12Y47}
set_property SNAPPING_MODE ON [get_pblocks p_4]
set_property IS_SOFT FALSE [get_pblocks p_4]

create_pblock p_5
add_cells_to_pblock [get_pblocks p_5] [get_cells -quiet [list pfm_top_i/dynamic_region/ydma_1/page5_inst]]
resize_pblock [get_pblocks p_5] -add {SLICE_X64Y240:SLICE_X95Y299}
resize_pblock [get_pblocks p_5] -add {DSP48E2_X13Y96:DSP48E2_X17Y119}
resize_pblock [get_pblocks p_5] -add {IOB_X0Y208:IOB_X0Y231}
resize_pblock [get_pblocks p_5] -add {RAMB18_X8Y96:RAMB18_X12Y119}
resize_pblock [get_pblocks p_5] -add {RAMB36_X8Y48:RAMB36_X12Y59}
set_property SNAPPING_MODE ON [get_pblocks p_5]
set_property IS_SOFT FALSE [get_pblocks p_5]

create_pblock p_6
add_cells_to_pblock [get_pblocks p_6] [get_cells -quiet [list pfm_top_i/dynamic_region/ydma_1/page6_inst]]
resize_pblock [get_pblocks p_6] -add {SLICE_X64Y300:SLICE_X95Y359}
resize_pblock [get_pblocks p_6] -add {DSP48E2_X13Y120:DSP48E2_X17Y143}
resize_pblock [get_pblocks p_6] -add {IOB_X0Y232:IOB_X0Y255}
resize_pblock [get_pblocks p_6] -add {RAMB18_X8Y120:RAMB18_X12Y143}
resize_pblock [get_pblocks p_6] -add {RAMB36_X8Y60:RAMB36_X12Y71}
set_property SNAPPING_MODE ON [get_pblocks p_6]
set_property IS_SOFT FALSE [get_pblocks p_6]


create_pblock p_7
add_cells_to_pblock [get_pblocks p_7] [get_cells -quiet [list pfm_top_i/dynamic_region/ydma_1/page7_inst]]
resize_pblock [get_pblocks p_7] -add {CLOCKREGION_X0Y6:CLOCKREGION_X0Y6}
set_property SNAPPING_MODE ON [get_pblocks p_7]
set_property IS_SOFT FALSE [get_pblocks p_7]

create_pblock p_8
add_cells_to_pblock [get_pblocks p_8] [get_cells -quiet [list pfm_top_i/dynamic_region/ydma_1/page8_inst]]
resize_pblock [get_pblocks p_8] -add {CLOCKREGION_X0Y5:CLOCKREGION_X0Y5}
set_property SNAPPING_MODE ON [get_pblocks p_8]
set_property IS_SOFT FALSE [get_pblocks p_8]

create_pblock p_9
add_cells_to_pblock [get_pblocks p_9] [get_cells -quiet [list pfm_top_i/dynamic_region/ydma_1/page9_inst]]
resize_pblock [get_pblocks p_9] -add {CLOCKREGION_X0Y4:CLOCKREGION_X0Y4}
set_property SNAPPING_MODE ON [get_pblocks p_9]
set_property IS_SOFT FALSE [get_pblocks p_9]

create_pblock p_10
add_cells_to_pblock [get_pblocks p_10] [get_cells -quiet [list pfm_top_i/dynamic_region/ydma_1/page10_inst]]
resize_pblock [get_pblocks p_10] -add {CLOCKREGION_X0Y3:CLOCKREGION_X0Y3}
set_property SNAPPING_MODE ON [get_pblocks p_10]
set_property IS_SOFT FALSE [get_pblocks p_10]


create_pblock p_11
add_cells_to_pblock [get_pblocks p_11] [get_cells -quiet [list pfm_top_i/dynamic_region/ydma_1/page11_inst]]
resize_pblock [get_pblocks p_11] -add {SLICE_X85Y360:SLICE_X95Y419}
resize_pblock [get_pblocks p_11] -add {DSP48E2_X16Y144:DSP48E2_X17Y167}
resize_pblock [get_pblocks p_11] -add {RAMB18_X12Y144:RAMB18_X12Y167}
resize_pblock [get_pblocks p_11] -add {RAMB36_X12Y72:RAMB36_X12Y83}
set_property SNAPPING_MODE ON [get_pblocks p_11]
set_property IS_SOFT FALSE [get_pblocks p_11]

create_pblock p_12
add_cells_to_pblock [get_pblocks p_12] [get_cells -quiet [list pfm_top_i/dynamic_region/ydma_1/page12_inst]]
resize_pblock [get_pblocks p_12] -add {SLICE_X74Y360:SLICE_X84Y419}
resize_pblock [get_pblocks p_12] -add {DSP48E2_X15Y144:DSP48E2_X15Y167}
resize_pblock [get_pblocks p_12] -add {RAMB18_X10Y144:RAMB18_X11Y167}
resize_pblock [get_pblocks p_12] -add {RAMB36_X10Y72:RAMB36_X11Y83}
set_property SNAPPING_MODE ON [get_pblocks p_12]
set_property IS_SOFT FALSE [get_pblocks p_12]

create_pblock p_13
add_cells_to_pblock [get_pblocks p_13] [get_cells -quiet [list pfm_top_i/dynamic_region/ydma_1/page13_inst]]
resize_pblock [get_pblocks p_13] -add {SLICE_X64Y360:SLICE_X73Y419}
resize_pblock [get_pblocks p_13] -add {DSP48E2_X13Y144:DSP48E2_X14Y167}
resize_pblock [get_pblocks p_13] -add {RAMB18_X8Y144:RAMB18_X9Y167}
resize_pblock [get_pblocks p_13] -add {RAMB36_X8Y72:RAMB36_X9Y83}
set_property SNAPPING_MODE ON [get_pblocks p_13]
set_property IS_SOFT FALSE [get_pblocks p_13]

create_pblock p_14
add_cells_to_pblock [get_pblocks p_14] [get_cells -quiet [list pfm_top_i/dynamic_region/ydma_1/page14_inst]]
resize_pblock [get_pblocks p_14] -add {SLICE_X52Y360:SLICE_X63Y419}
resize_pblock [get_pblocks p_14] -add {DSP48E2_X10Y144:DSP48E2_X12Y167}
resize_pblock [get_pblocks p_14] -add {RAMB18_X7Y144:RAMB18_X7Y167}
resize_pblock [get_pblocks p_14] -add {RAMB36_X7Y72:RAMB36_X7Y83}
set_property SNAPPING_MODE ON [get_pblocks p_14]
set_property IS_SOFT FALSE [get_pblocks p_14]

create_pblock p_15
add_cells_to_pblock [get_pblocks p_15] [get_cells -quiet [list pfm_top_i/dynamic_region/ydma_1/page15_inst]]
resize_pblock [get_pblocks p_15] -add {SLICE_X44Y360:SLICE_X51Y419}
resize_pblock [get_pblocks p_15] -add {DSP48E2_X9Y144:DSP48E2_X9Y167}
resize_pblock [get_pblocks p_15] -add {RAMB18_X6Y144:RAMB18_X6Y167}
resize_pblock [get_pblocks p_15] -add {RAMB36_X6Y72:RAMB36_X6Y83}
set_property SNAPPING_MODE ON [get_pblocks p_15]
set_property IS_SOFT FALSE [get_pblocks p_15]

create_pblock p_16
add_cells_to_pblock [get_pblocks p_16] [get_cells -quiet [list pfm_top_i/dynamic_region/ydma_1/page16_inst]]
resize_pblock [get_pblocks p_16] -add {SLICE_X37Y360:SLICE_X43Y419}
resize_pblock [get_pblocks p_16] -add {DSP48E2_X7Y144:DSP48E2_X8Y167}
resize_pblock [get_pblocks p_16] -add {RAMB18_X5Y144:RAMB18_X5Y167}
resize_pblock [get_pblocks p_16] -add {RAMB36_X5Y72:RAMB36_X5Y83}
set_property SNAPPING_MODE ON [get_pblocks p_16]
set_property IS_SOFT FALSE [get_pblocks p_16]

create_pblock p_17
add_cells_to_pblock [get_pblocks p_17] [get_cells -quiet [list pfm_top_i/dynamic_region/ydma_1/page17_inst]]
resize_pblock [get_pblocks p_17] -add {SLICE_X29Y360:SLICE_X36Y419}
resize_pblock [get_pblocks p_17] -add {DSP48E2_X6Y144:DSP48E2_X6Y167}
resize_pblock [get_pblocks p_17] -add {RAMB18_X4Y144:RAMB18_X4Y167}
resize_pblock [get_pblocks p_17] -add {RAMB36_X4Y72:RAMB36_X4Y83}
set_property SNAPPING_MODE ON [get_pblocks p_17]
set_property IS_SOFT FALSE [get_pblocks p_17]