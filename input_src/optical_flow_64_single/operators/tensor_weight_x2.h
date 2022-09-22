void tensor_weight_x2(hls::stream< ap_uint<96> > &Input_1,
		     hls::stream< ap_uint<96> > &Output_1,
		     hls::stream< ap_uint<96> > &Output_2);
#pragma map_target=HW page_num=15  inst_mem_size = 32768
