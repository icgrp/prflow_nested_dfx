#include "../host/typedefs.h"

void dummy_consumer (
		hls::stream<ap_uint<32> > & Input_1,
		hls::stream<ap_uint<32> > & Input_2,
		hls::stream<ap_uint<32> > & Input_3,
		hls::stream<ap_uint<32> > & Input_4
		)
{
#pragma HLS INTERFACE axis register port=Input_1
#pragma HLS INTERFACE axis register port=Input_2
#pragma HLS INTERFACE axis register port=Input_3
#pragma HLS INTERFACE axis register port=Input_4

	bit32 input_1_tmp, input_2_tmp, input_3_tmp, input_4_tmp; 

	input_1_tmp = Input_1.read();
	input_2_tmp = Input_2.read();
	input_3_tmp = Input_3.read();
	input_4_tmp = Input_4.read();

}