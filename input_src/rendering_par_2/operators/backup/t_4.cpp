#include "../host/typedefs.h"

void t_4 (
		hls::stream<ap_uint<32> > & Input_1,
		hls::stream<ap_uint<32> > & Output_1,
		hls::stream<ap_uint<32> > & Output_2
		)
{
#pragma HLS INTERFACE axis register port=Input_1
#pragma HLS INTERFACE axis register port=Output_1
#pragma HLS INTERFACE axis register port=Output_2

	bit32 input_1_tmp, input_2_tmp;

	input_1_tmp = Input_1.read();
	Output_1.write(input_1_tmp); // rasterization2_m
	Output_2.write(input_1_tmp); // rasterization2_m_1

}