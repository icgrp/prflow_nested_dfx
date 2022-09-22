void data_transfer (
		hls::stream<ap_uint<512> > & Input_1,
		hls::stream<ap_uint<128> > & Output_1
		);

#pragma map_target = HW inst_mem_size = 32768
#pragma HLS_PR=1 clb =4 ff = 1 bram =2.4 dsp =1.2

