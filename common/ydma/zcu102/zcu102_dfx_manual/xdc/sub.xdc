
create_pblock p_2
add_cells_to_pblock [get_pblocks p_2] [get_cells -quiet [list pfm_top_i/dynamic_region/ydma_1/page2_inst]]
resize_pblock [get_pblocks p_2] -add {SLICE_X79Y0:SLICE_X95Y59}
resize_pblock [get_pblocks p_2] -add {DSP48E2_X16Y0:DSP48E2_X17Y23}
resize_pblock [get_pblocks p_2] -add {IOB_X0Y0:IOB_X0Y37}
resize_pblock [get_pblocks p_2] -add {RAMB18_X10Y0:RAMB18_X12Y23}
resize_pblock [get_pblocks p_2] -add {RAMB36_X10Y0:RAMB36_X12Y11}
set_property SNAPPING_MODE ON [get_pblocks p_2]
set_property IS_SOFT FALSE [get_pblocks p_2]
create_pblock p_3
add_cells_to_pblock [get_pblocks p_3] [get_cells -quiet [list pfm_top_i/dynamic_region/ydma_1/page3_inst]]
resize_pblock [get_pblocks p_3] -add {SLICE_X79Y120:SLICE_X95Y179}
resize_pblock [get_pblocks p_3] -add {CFGIO_SITE_X0Y0:CFGIO_SITE_X0Y0}
resize_pblock [get_pblocks p_3] -add {DSP48E2_X16Y48:DSP48E2_X17Y71}
resize_pblock [get_pblocks p_3] -add {RAMB18_X10Y48:RAMB18_X12Y71}
resize_pblock [get_pblocks p_3] -add {RAMB36_X10Y24:RAMB36_X12Y35}
resize_pblock [get_pblocks p_3] -add {SYSMONE4_X0Y0:SYSMONE4_X0Y0}
set_property SNAPPING_MODE ON [get_pblocks p_3]
set_property IS_SOFT FALSE [get_pblocks p_3]
create_pblock p_4
add_cells_to_pblock [get_pblocks p_4] [get_cells -quiet [list pfm_top_i/dynamic_region/ydma_1/page4_inst]]
resize_pblock [get_pblocks p_4] -add {SLICE_X79Y180:SLICE_X95Y239}
resize_pblock [get_pblocks p_4] -add {DSP48E2_X16Y72:DSP48E2_X17Y95}
resize_pblock [get_pblocks p_4] -add {IOB_X0Y156:IOB_X0Y193}
resize_pblock [get_pblocks p_4] -add {RAMB18_X10Y72:RAMB18_X12Y95}
resize_pblock [get_pblocks p_4] -add {RAMB36_X10Y36:RAMB36_X12Y47}
set_property SNAPPING_MODE ON [get_pblocks p_4]
set_property IS_SOFT FALSE [get_pblocks p_4]
create_pblock p_5
add_cells_to_pblock [get_pblocks p_5] [get_cells -quiet [list pfm_top_i/dynamic_region/ydma_1/page5_inst]]
resize_pblock [get_pblocks p_5] -add {SLICE_X79Y240:SLICE_X95Y299}
resize_pblock [get_pblocks p_5] -add {DSP48E2_X16Y96:DSP48E2_X17Y119}
resize_pblock [get_pblocks p_5] -add {IOB_X0Y208:IOB_X0Y231}
resize_pblock [get_pblocks p_5] -add {RAMB18_X10Y96:RAMB18_X12Y119}
resize_pblock [get_pblocks p_5] -add {RAMB36_X10Y48:RAMB36_X12Y59}
set_property SNAPPING_MODE ON [get_pblocks p_5]
set_property IS_SOFT FALSE [get_pblocks p_5]
create_pblock p_6
add_cells_to_pblock [get_pblocks p_6] [get_cells -quiet [list pfm_top_i/dynamic_region/ydma_1/page6_inst]]
resize_pblock [get_pblocks p_6] -add {SLICE_X79Y300:SLICE_X95Y359}
resize_pblock [get_pblocks p_6] -add {DSP48E2_X16Y120:DSP48E2_X17Y143}
resize_pblock [get_pblocks p_6] -add {IOB_X0Y232:IOB_X0Y255}
resize_pblock [get_pblocks p_6] -add {RAMB18_X10Y120:RAMB18_X12Y143}
resize_pblock [get_pblocks p_6] -add {RAMB36_X10Y60:RAMB36_X12Y71}
set_property SNAPPING_MODE ON [get_pblocks p_6]
set_property IS_SOFT FALSE [get_pblocks p_6]
create_pblock p_7
add_cells_to_pblock [get_pblocks p_7] [get_cells -quiet [list pfm_top_i/dynamic_region/ydma_1/page7_inst]]
resize_pblock [get_pblocks p_7] -add {SLICE_X79Y360:SLICE_X95Y419}
resize_pblock [get_pblocks p_7] -add {DSP48E2_X16Y144:DSP48E2_X17Y167}
resize_pblock [get_pblocks p_7] -add {IOB_X0Y256:IOB_X0Y279}
resize_pblock [get_pblocks p_7] -add {RAMB18_X10Y144:RAMB18_X12Y167}
resize_pblock [get_pblocks p_7] -add {RAMB36_X10Y72:RAMB36_X12Y83}
set_property SNAPPING_MODE ON [get_pblocks p_7]
set_property IS_SOFT FALSE [get_pblocks p_7]
create_pblock p_8
add_cells_to_pblock [get_pblocks p_8] [get_cells -quiet [list pfm_top_i/dynamic_region/ydma_1/page8_inst]]
resize_pblock [get_pblocks p_8] -add {SLICE_X55Y360:SLICE_X72Y419}
resize_pblock [get_pblocks p_8] -add {DSP48E2_X11Y144:DSP48E2_X13Y167}
resize_pblock [get_pblocks p_8] -add {RAMB18_X7Y144:RAMB18_X9Y167}
resize_pblock [get_pblocks p_8] -add {RAMB36_X7Y72:RAMB36_X9Y83}
set_property SNAPPING_MODE ON [get_pblocks p_8]
set_property IS_SOFT FALSE [get_pblocks p_8]
create_pblock p_9
add_cells_to_pblock [get_pblocks p_9] [get_cells -quiet [list pfm_top_i/dynamic_region/ydma_1/page9_inst]]
resize_pblock [get_pblocks p_9] -add {SLICE_X37Y360:SLICE_X54Y419}
resize_pblock [get_pblocks p_9] -add {DSP48E2_X7Y144:DSP48E2_X10Y167}
resize_pblock [get_pblocks p_9] -add {RAMB18_X5Y144:RAMB18_X6Y167}
resize_pblock [get_pblocks p_9] -add {RAMB36_X5Y72:RAMB36_X6Y83}
set_property SNAPPING_MODE ON [get_pblocks p_9]
set_property IS_SOFT FALSE [get_pblocks p_9]
create_pblock p_10
add_cells_to_pblock [get_pblocks p_10] [get_cells -quiet [list pfm_top_i/dynamic_region/ydma_1/page10_inst]]
resize_pblock [get_pblocks p_10] -add {SLICE_X55Y300:SLICE_X72Y359}
resize_pblock [get_pblocks p_10] -add {DSP48E2_X11Y120:DSP48E2_X13Y143}
resize_pblock [get_pblocks p_10] -add {RAMB18_X7Y120:RAMB18_X9Y143}
resize_pblock [get_pblocks p_10] -add {RAMB36_X7Y60:RAMB36_X9Y71}
set_property SNAPPING_MODE ON [get_pblocks p_10]
set_property IS_SOFT FALSE [get_pblocks p_10]
create_pblock p_11
add_cells_to_pblock [get_pblocks p_11] [get_cells -quiet [list pfm_top_i/dynamic_region/ydma_1/page11_inst]]
resize_pblock [get_pblocks p_11] -add {SLICE_X37Y300:SLICE_X54Y359}
resize_pblock [get_pblocks p_11] -add {DSP48E2_X7Y120:DSP48E2_X10Y143}
resize_pblock [get_pblocks p_11] -add {RAMB18_X5Y120:RAMB18_X6Y143}
resize_pblock [get_pblocks p_11] -add {RAMB36_X5Y60:RAMB36_X6Y71}
set_property SNAPPING_MODE ON [get_pblocks p_11]
set_property IS_SOFT FALSE [get_pblocks p_11]
create_pblock p_12
add_cells_to_pblock [get_pblocks p_12] [get_cells -quiet [list pfm_top_i/dynamic_region/ydma_1/page12_inst]]
resize_pblock [get_pblocks p_12] -add {SLICE_X55Y240:SLICE_X72Y299}
resize_pblock [get_pblocks p_12] -add {DSP48E2_X11Y96:DSP48E2_X13Y119}
resize_pblock [get_pblocks p_12] -add {RAMB18_X7Y96:RAMB18_X9Y119}
resize_pblock [get_pblocks p_12] -add {RAMB36_X7Y48:RAMB36_X9Y59}
set_property SNAPPING_MODE ON [get_pblocks p_12]
set_property IS_SOFT FALSE [get_pblocks p_12]
create_pblock p_13
add_cells_to_pblock [get_pblocks p_13] [get_cells -quiet [list pfm_top_i/dynamic_region/ydma_1/page13_inst]]
resize_pblock [get_pblocks p_13] -add {SLICE_X37Y240:SLICE_X54Y299}
resize_pblock [get_pblocks p_13] -add {DSP48E2_X7Y96:DSP48E2_X10Y119}
resize_pblock [get_pblocks p_13] -add {RAMB18_X5Y96:RAMB18_X6Y119}
resize_pblock [get_pblocks p_13] -add {RAMB36_X5Y48:RAMB36_X6Y59}
set_property SNAPPING_MODE ON [get_pblocks p_13]
set_property IS_SOFT FALSE [get_pblocks p_13]
create_pblock p_14
add_cells_to_pblock [get_pblocks p_14] [get_cells -quiet [list pfm_top_i/dynamic_region/ydma_1/page14_inst]]
resize_pblock [get_pblocks p_14] -add {SLICE_X61Y120:SLICE_X78Y179}
resize_pblock [get_pblocks p_14] -add {DSP48E2_X12Y48:DSP48E2_X15Y71}
resize_pblock [get_pblocks p_14] -add {RAMB18_X8Y48:RAMB18_X9Y71}
resize_pblock [get_pblocks p_14] -add {RAMB36_X8Y24:RAMB36_X9Y35}
set_property SNAPPING_MODE ON [get_pblocks p_14]
set_property IS_SOFT FALSE [get_pblocks p_14]
create_pblock p_15
add_cells_to_pblock [get_pblocks p_15] [get_cells -quiet [list pfm_top_i/dynamic_region/ydma_1/page15_inst]]
resize_pblock [get_pblocks p_15] -add {SLICE_X61Y0:SLICE_X78Y59}
resize_pblock [get_pblocks p_15] -add {DSP48E2_X12Y0:DSP48E2_X15Y23}
resize_pblock [get_pblocks p_15] -add {RAMB18_X8Y0:RAMB18_X9Y23}
resize_pblock [get_pblocks p_15] -add {RAMB36_X8Y0:RAMB36_X9Y11}
set_property SNAPPING_MODE ON [get_pblocks p_15]
set_property IS_SOFT FALSE [get_pblocks p_15]
create_pblock p_16
add_cells_to_pblock [get_pblocks p_16] [get_cells -quiet [list pfm_top_i/dynamic_region/ydma_1/page16_inst]]
resize_pblock [get_pblocks p_16] -add {SLICE_X16Y180:SLICE_X33Y239}
resize_pblock [get_pblocks p_16] -add {DSP48E2_X3Y72:DSP48E2_X5Y95}
resize_pblock [get_pblocks p_16] -add {RAMB18_X2Y72:RAMB18_X4Y95}
resize_pblock [get_pblocks p_16] -add {RAMB36_X2Y36:RAMB36_X4Y47}
set_property SNAPPING_MODE ON [get_pblocks p_16]
set_property IS_SOFT FALSE [get_pblocks p_16]
create_pblock p_17
add_cells_to_pblock [get_pblocks p_17] [get_cells -quiet [list pfm_top_i/dynamic_region/ydma_1/page17_inst]]
resize_pblock [get_pblocks p_17] -add {SLICE_X0Y180:SLICE_X15Y239}
resize_pblock [get_pblocks p_17] -add {DSP48E2_X0Y72:DSP48E2_X2Y95}
resize_pblock [get_pblocks p_17] -add {GTHE4_CHANNEL_X0Y0:GTHE4_CHANNEL_X0Y3}
resize_pblock [get_pblocks p_17] -add {GTHE4_COMMON_X0Y0:GTHE4_COMMON_X0Y0}
resize_pblock [get_pblocks p_17] -add {RAMB18_X0Y72:RAMB18_X1Y95}
resize_pblock [get_pblocks p_17] -add {RAMB36_X0Y36:RAMB36_X1Y47}
set_property SNAPPING_MODE ON [get_pblocks p_17]
set_property IS_SOFT FALSE [get_pblocks p_17]
create_pblock p_18
add_cells_to_pblock [get_pblocks p_18] [get_cells -quiet [list pfm_top_i/dynamic_region/ydma_1/page18_inst]]
resize_pblock [get_pblocks p_18] -add {SLICE_X16Y240:SLICE_X33Y299}
resize_pblock [get_pblocks p_18] -add {DSP48E2_X3Y96:DSP48E2_X5Y119}
resize_pblock [get_pblocks p_18] -add {RAMB18_X2Y96:RAMB18_X4Y119}
resize_pblock [get_pblocks p_18] -add {RAMB36_X2Y48:RAMB36_X4Y59}
set_property SNAPPING_MODE ON [get_pblocks p_18]
set_property IS_SOFT FALSE [get_pblocks p_18]
create_pblock p_19
add_cells_to_pblock [get_pblocks p_19] [get_cells -quiet [list pfm_top_i/dynamic_region/ydma_1/page19_inst]]
resize_pblock [get_pblocks p_19] -add {SLICE_X0Y240:SLICE_X15Y299}
resize_pblock [get_pblocks p_19] -add {DSP48E2_X0Y96:DSP48E2_X2Y119}
resize_pblock [get_pblocks p_19] -add {GTHE4_CHANNEL_X0Y4:GTHE4_CHANNEL_X0Y7}
resize_pblock [get_pblocks p_19] -add {GTHE4_COMMON_X0Y1:GTHE4_COMMON_X0Y1}
resize_pblock [get_pblocks p_19] -add {RAMB18_X0Y96:RAMB18_X1Y119}
resize_pblock [get_pblocks p_19] -add {RAMB36_X0Y48:RAMB36_X1Y59}
set_property SNAPPING_MODE ON [get_pblocks p_19]
set_property IS_SOFT FALSE [get_pblocks p_19]
create_pblock p_20
add_cells_to_pblock [get_pblocks p_20] [get_cells -quiet [list pfm_top_i/dynamic_region/ydma_1/page20_inst]]
resize_pblock [get_pblocks p_20] -add {SLICE_X16Y300:SLICE_X33Y359}
resize_pblock [get_pblocks p_20] -add {DSP48E2_X3Y120:DSP48E2_X5Y143}
resize_pblock [get_pblocks p_20] -add {RAMB18_X2Y120:RAMB18_X4Y143}
resize_pblock [get_pblocks p_20] -add {RAMB36_X2Y60:RAMB36_X4Y71}
set_property SNAPPING_MODE ON [get_pblocks p_20]
set_property IS_SOFT FALSE [get_pblocks p_20]
create_pblock p_21
add_cells_to_pblock [get_pblocks p_21] [get_cells -quiet [list pfm_top_i/dynamic_region/ydma_1/page21_inst]]
resize_pblock [get_pblocks p_21] -add {SLICE_X0Y300:SLICE_X15Y359}
resize_pblock [get_pblocks p_21] -add {DSP48E2_X0Y120:DSP48E2_X2Y143}
resize_pblock [get_pblocks p_21] -add {GTHE4_CHANNEL_X0Y8:GTHE4_CHANNEL_X0Y11}
resize_pblock [get_pblocks p_21] -add {GTHE4_COMMON_X0Y2:GTHE4_COMMON_X0Y2}
resize_pblock [get_pblocks p_21] -add {RAMB18_X0Y120:RAMB18_X1Y143}
resize_pblock [get_pblocks p_21] -add {RAMB36_X0Y60:RAMB36_X1Y71}
set_property SNAPPING_MODE ON [get_pblocks p_21]
set_property IS_SOFT FALSE [get_pblocks p_21]
create_pblock p_22
add_cells_to_pblock [get_pblocks p_22] [get_cells -quiet [list pfm_top_i/dynamic_region/ydma_1/page22_inst]]
resize_pblock [get_pblocks p_22] -add {SLICE_X16Y360:SLICE_X33Y419}
resize_pblock [get_pblocks p_22] -add {DSP48E2_X3Y144:DSP48E2_X5Y167}
resize_pblock [get_pblocks p_22] -add {RAMB18_X2Y144:RAMB18_X4Y167}
resize_pblock [get_pblocks p_22] -add {RAMB36_X2Y72:RAMB36_X4Y83}
set_property SNAPPING_MODE ON [get_pblocks p_22]
set_property IS_SOFT FALSE [get_pblocks p_22]
create_pblock p_23
add_cells_to_pblock [get_pblocks p_23] [get_cells -quiet [list pfm_top_i/dynamic_region/ydma_1/page23_inst]]
resize_pblock [get_pblocks p_23] -add {SLICE_X0Y360:SLICE_X15Y419}
resize_pblock [get_pblocks p_23] -add {DSP48E2_X0Y144:DSP48E2_X2Y167}
resize_pblock [get_pblocks p_23] -add {GTHE4_CHANNEL_X0Y12:GTHE4_CHANNEL_X0Y15}
resize_pblock [get_pblocks p_23] -add {GTHE4_COMMON_X0Y3:GTHE4_COMMON_X0Y3}
resize_pblock [get_pblocks p_23] -add {RAMB18_X0Y144:RAMB18_X1Y167}
resize_pblock [get_pblocks p_23] -add {RAMB36_X0Y72:RAMB36_X1Y83}
set_property SNAPPING_MODE ON [get_pblocks p_23]
set_property IS_SOFT FALSE [get_pblocks p_23]