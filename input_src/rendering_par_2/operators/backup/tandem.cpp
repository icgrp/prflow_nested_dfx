#include "../host/typedefs.h"

// void tandem (
// 		hls::stream<ap_uint<32> > &  ,
// 		hls::stream<ap_uint<32> > & Input_2,		
// 		hls::stream<ap_uint<32> > & Output_1,
// 		hls::stream<ap_uint<32> > & Output_2,
// 		hls::stream<ap_uint<32> > & Output_3,
// 		hls::stream<ap_uint<32> > & Output_4
// 		)
// {
// #pragma HLS INTERFACE axis register port=Input_1
// #pragma HLS INTERFACE axis register port=Input_2
// #pragma HLS INTERFACE axis register port=Output_1
// #pragma HLS INTERFACE axis register port=Output_2
// #pragma HLS INTERFACE axis register port=Output_3
// #pragma HLS INTERFACE axis register port=Output_4

// 	bit32 input_1_tmp, input_2_tmp; 
// 	bit32 output_1_tmp, output_2_tmp, output_3_tmp, output_4_tmp;

// 	input_1_tmp = Input_1.read();
// 	Output_1.write(input_1_tmp); // rasterization2_m
// 	Output_3.write(input_1_tmp); // rasterization2_m' for training
// 	input_1_tmp = Input_1.read();
// 	Output_1.write(input_1_tmp); // rasterization2_m
// 	Output_3.write(input_1_tmp); // rasterization2_m' for training
// 	input_1_tmp = Input_1.read();
// 	Output_1.write(input_1_tmp); // rasterization2_m
// 	Output_3.write(input_1_tmp); // rasterization2_m' for training
// 	input_1_tmp = Input_1.read();
// 	Output_1.write(input_1_tmp); // rasterization2_m
// 	Output_3.write(input_1_tmp); // rasterization2_m' for training


// 	input_2_tmp = Input_2.read();
// 	Output_2.write(input_2_tmp); // rasterization2_m
// 	Output_4.write(input_2_tmp); // rasterization2_m' for training
// 	input_2_tmp = Input_2.read();
// 	Output_2.write(input_2_tmp); // rasterization2_m
// 	Output_4.write(input_2_tmp); // rasterization2_m' for training
// 	input_2_tmp = Input_2.read();
// 	Output_2.write(input_2_tmp); // rasterization2_m
// 	Output_4.write(input_2_tmp); // rasterization2_m' for training
// 	input_2_tmp = Input_2.read();
// 	Output_2.write(input_2_tmp); // rasterization2_m
// 	Output_4.write(input_2_tmp); // rasterization2_m' for training
// }


// void tandem (
// 		hls::stream<ap_uint<32> > & Input_1,
// 		hls::stream<ap_uint<32> > & Input_2,		
// 		hls::stream<ap_uint<32> > & Output_1,
// 		hls::stream<ap_uint<32> > & Output_2,
// 		hls::stream<ap_uint<32> > & Output_3,
// 		hls::stream<ap_uint<32> > & Output_4
// 		)
// {
// #pragma HLS INTERFACE axis register port=Input_1
// #pragma HLS INTERFACE axis register port=Input_2
// #pragma HLS INTERFACE axis register port=Output_1
// #pragma HLS INTERFACE axis register port=Output_2
// #pragma HLS INTERFACE axis register port=Output_3
// #pragma HLS INTERFACE axis register port=Output_4

// 	bit32 input_1_tmp, input_2_tmp;

// 	input_1_tmp = Input_1.read();
// 	Output_1.write(input_1_tmp); // rasterization2_m
// 	Output_3.write(input_1_tmp); // rasterization2_m_1
// 	input_1_tmp = Input_1.read();
// 	Output_1.write(input_1_tmp); // rasterization2_m
// 	Output_3.write(input_1_tmp); // rasterization2_m_1	
// 	input_1_tmp = Input_1.read();
// 	Output_1.write(input_1_tmp); // rasterization2_m
// 	Output_3.write(input_1_tmp); // rasterization2_m_1
// 	input_1_tmp = Input_1.read();
// 	Output_1.write(input_1_tmp); // rasterization2_m
// 	Output_3.write(input_1_tmp); // rasterization2_m_1

// 	input_2_tmp = Input_2.read();
// 	Output_2.write(input_2_tmp); // rasterization2_m
// 	Output_4.write(input_2_tmp); // rasterization2_m_1
// 	input_2_tmp = Input_2.read();
// 	Output_2.write(input_2_tmp); // rasterization2_m
// 	Output_4.write(input_2_tmp); // rasterization2_m_1
// 	input_2_tmp = Input_2.read();
// 	Output_2.write(input_2_tmp); // rasterization2_m
// 	Output_4.write(input_2_tmp); // rasterization2_m_1
// 	input_2_tmp = Input_2.read();
// 	Output_2.write(input_2_tmp); // rasterization2_m
// 	Output_4.write(input_2_tmp); // rasterization2_m_1

// }


void tandem (
		hls::stream<ap_uint<32> > & Input_1,
		hls::stream<ap_uint<32> > & Input_2,		
		hls::stream<ap_uint<32> > & Output_1,
		hls::stream<ap_uint<32> > & Output_2,
		hls::stream<ap_uint<32> > & Output_3,
		hls::stream<ap_uint<32> > & Output_4
		)
{
#pragma HLS INTERFACE axis register port=Input_1
#pragma HLS INTERFACE axis register port=Input_2
#pragma HLS INTERFACE axis register port=Output_1
#pragma HLS INTERFACE axis register port=Output_2
#pragma HLS INTERFACE axis register port=Output_3
#pragma HLS INTERFACE axis register port=Output_4

	bit32 input_1_tmp, input_2_tmp;

	input_1_tmp = Input_1.read();
	Output_1.write(input_1_tmp); // rasterization2_m
	Output_3.write(input_1_tmp); // rasterization2_m_1

	input_2_tmp = Input_2.read();
	Output_2.write(input_2_tmp); // rasterization2_m
	Output_4.write(input_2_tmp); // rasterization2_m_1

}