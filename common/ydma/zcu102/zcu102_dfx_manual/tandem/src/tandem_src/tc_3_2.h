void tc_3_2 (
		hls::stream<ap_uint<32> > & Input_1,
		hls::stream<ap_uint<32> > & Input_2,
		hls::stream<ap_uint<32> > & Input_3,
		hls::stream<ap_uint<32> > & Input_4,
		hls::stream<ap_uint<32> > & Output_1,
		hls::stream<ap_uint<32> > & Output_2,
        hls::stream<ap_uint<32> > & Output_3
		);
#pragma map_target = HW
