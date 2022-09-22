create_pblock p_2
add_cells_to_pblock [get_pblocks p_2] [get_cells -quiet [list pfm_top_i/dynamic_region/ydma_1/page2_inst]]
resize_pblock [get_pblocks p_2] -add {SLICE_X56Y0:SLICE_X95Y59}
resize_pblock [get_pblocks p_2] -add {DSP48E2_X12Y0:DSP48E2_X17Y23}
resize_pblock [get_pblocks p_2] -add {IOB_X0Y0:IOB_X0Y37}
resize_pblock [get_pblocks p_2] -add {RAMB18_X7Y0:RAMB18_X12Y23}
resize_pblock [get_pblocks p_2] -add {RAMB36_X7Y0:RAMB36_X12Y11}
set_property SNAPPING_MODE ON [get_pblocks p_2]
set_property IS_SOFT FALSE [get_pblocks p_2]
create_pblock p_3
add_cells_to_pblock [get_pblocks p_3] [get_cells -quiet [list pfm_top_i/dynamic_region/ydma_1/page3_inst]]
resize_pblock [get_pblocks p_3] -add {SLICE_X56Y120:SLICE_X95Y179}
resize_pblock [get_pblocks p_3] -add {CFGIO_SITE_X0Y0:CFGIO_SITE_X0Y0}
resize_pblock [get_pblocks p_3] -add {DSP48E2_X12Y48:DSP48E2_X17Y71}
resize_pblock [get_pblocks p_3] -add {RAMB18_X7Y48:RAMB18_X12Y71}
resize_pblock [get_pblocks p_3] -add {RAMB36_X7Y24:RAMB36_X12Y35}
resize_pblock [get_pblocks p_3] -add {SYSMONE4_X0Y0:SYSMONE4_X0Y0}
set_property SNAPPING_MODE ON [get_pblocks p_3]
set_property IS_SOFT FALSE [get_pblocks p_3]
create_pblock p_4
add_cells_to_pblock [get_pblocks p_4] [get_cells -quiet [list pfm_top_i/dynamic_region/ydma_1/page4_inst]]
resize_pblock [get_pblocks p_4] -add {SLICE_X56Y180:SLICE_X95Y239}
resize_pblock [get_pblocks p_4] -add {DSP48E2_X12Y72:DSP48E2_X17Y95}
resize_pblock [get_pblocks p_4] -add {IOB_X0Y156:IOB_X0Y193}
resize_pblock [get_pblocks p_4] -add {RAMB18_X7Y72:RAMB18_X12Y95}
resize_pblock [get_pblocks p_4] -add {RAMB36_X7Y36:RAMB36_X12Y47}
set_property SNAPPING_MODE ON [get_pblocks p_4]
set_property IS_SOFT FALSE [get_pblocks p_4]
create_pblock p_5
add_cells_to_pblock [get_pblocks p_5] [get_cells -quiet [list pfm_top_i/dynamic_region/ydma_1/page5_inst]]
resize_pblock [get_pblocks p_5] -add {SLICE_X56Y300:SLICE_X95Y359}
resize_pblock [get_pblocks p_5] -add {DSP48E2_X12Y120:DSP48E2_X17Y143}
resize_pblock [get_pblocks p_5] -add {IOB_X0Y232:IOB_X0Y255}
resize_pblock [get_pblocks p_5] -add {RAMB18_X7Y120:RAMB18_X12Y143}
resize_pblock [get_pblocks p_5] -add {RAMB36_X7Y60:RAMB36_X12Y71}
set_property SNAPPING_MODE ON [get_pblocks p_5]
set_property IS_SOFT FALSE [get_pblocks p_5]
create_pblock p_6
add_cells_to_pblock [get_pblocks p_6] [get_cells -quiet [list pfm_top_i/dynamic_region/ydma_1/page6_inst]]
resize_pblock [get_pblocks p_6] -add {SLICE_X56Y360:SLICE_X95Y419}
resize_pblock [get_pblocks p_6] -add {DSP48E2_X12Y144:DSP48E2_X17Y167}
resize_pblock [get_pblocks p_6] -add {IOB_X0Y256:IOB_X0Y279}
resize_pblock [get_pblocks p_6] -add {RAMB18_X7Y144:RAMB18_X12Y167}
resize_pblock [get_pblocks p_6] -add {RAMB36_X7Y72:RAMB36_X12Y83}
set_property SNAPPING_MODE ON [get_pblocks p_6]
set_property IS_SOFT FALSE [get_pblocks p_6]
create_pblock p_7
add_cells_to_pblock [get_pblocks p_7] [get_cells -quiet [list pfm_top_i/dynamic_region/ydma_1/page7_inst]]
resize_pblock [get_pblocks p_7] -add {SLICE_X0Y360:SLICE_X39Y419}
resize_pblock [get_pblocks p_7] -add {DSP48E2_X0Y144:DSP48E2_X6Y167}
resize_pblock [get_pblocks p_7] -add {GTHE4_CHANNEL_X0Y12:GTHE4_CHANNEL_X0Y15}
resize_pblock [get_pblocks p_7] -add {GTHE4_COMMON_X0Y3:GTHE4_COMMON_X0Y3}
resize_pblock [get_pblocks p_7] -add {RAMB18_X0Y144:RAMB18_X5Y167}
resize_pblock [get_pblocks p_7] -add {RAMB36_X0Y72:RAMB36_X5Y83}
set_property SNAPPING_MODE ON [get_pblocks p_7]
set_property IS_SOFT FALSE [get_pblocks p_7]
create_pblock p_8
add_cells_to_pblock [get_pblocks p_8] [get_cells -quiet [list pfm_top_i/dynamic_region/ydma_1/page8_inst]]
resize_pblock [get_pblocks p_8] -add {SLICE_X0Y300:SLICE_X39Y359}
resize_pblock [get_pblocks p_8] -add {DSP48E2_X0Y120:DSP48E2_X6Y143}
resize_pblock [get_pblocks p_8] -add {GTHE4_CHANNEL_X0Y8:GTHE4_CHANNEL_X0Y11}
resize_pblock [get_pblocks p_8] -add {GTHE4_COMMON_X0Y2:GTHE4_COMMON_X0Y2}
resize_pblock [get_pblocks p_8] -add {RAMB18_X0Y120:RAMB18_X5Y143}
resize_pblock [get_pblocks p_8] -add {RAMB36_X0Y60:RAMB36_X5Y71}
set_property SNAPPING_MODE ON [get_pblocks p_8]
set_property IS_SOFT FALSE [get_pblocks p_8]
create_pblock p_9
add_cells_to_pblock [get_pblocks p_9] [get_cells -quiet [list pfm_top_i/dynamic_region/ydma_1/page9_inst]]
resize_pblock [get_pblocks p_9] -add {SLICE_X0Y240:SLICE_X39Y299}
resize_pblock [get_pblocks p_9] -add {DSP48E2_X0Y96:DSP48E2_X6Y119}
resize_pblock [get_pblocks p_9] -add {GTHE4_CHANNEL_X0Y4:GTHE4_CHANNEL_X0Y7}
resize_pblock [get_pblocks p_9] -add {GTHE4_COMMON_X0Y1:GTHE4_COMMON_X0Y1}
resize_pblock [get_pblocks p_9] -add {RAMB18_X0Y96:RAMB18_X5Y119}
resize_pblock [get_pblocks p_9] -add {RAMB36_X0Y48:RAMB36_X5Y59}
set_property SNAPPING_MODE ON [get_pblocks p_9]
set_property IS_SOFT FALSE [get_pblocks p_9]
create_pblock p_10
add_cells_to_pblock [get_pblocks p_10] [get_cells -quiet [list pfm_top_i/dynamic_region/ydma_1/page10_inst]]
resize_pblock [get_pblocks p_10] -add {SLICE_X0Y180:SLICE_X39Y239}
resize_pblock [get_pblocks p_10] -add {DSP48E2_X0Y72:DSP48E2_X6Y95}
resize_pblock [get_pblocks p_10] -add {GTHE4_CHANNEL_X0Y0:GTHE4_CHANNEL_X0Y3}
resize_pblock [get_pblocks p_10] -add {GTHE4_COMMON_X0Y0:GTHE4_COMMON_X0Y0}
resize_pblock [get_pblocks p_10] -add {RAMB18_X0Y72:RAMB18_X5Y95}
resize_pblock [get_pblocks p_10] -add {RAMB36_X0Y36:RAMB36_X5Y47}
set_property SNAPPING_MODE ON [get_pblocks p_10]
set_property IS_SOFT FALSE [get_pblocks p_10]
