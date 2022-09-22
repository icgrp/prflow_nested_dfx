#include "../host/typedefs.h"

void t2_1 (
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

	// bit32 input_1_tmp, input_2_tmp;

	// input_1_tmp = Input_1.read();
	// Output_1.write(input_1_tmp); // rasterization2_m
	// Output_2.write(input_1_tmp); // rasterization2_m_1

	// input_2_tmp = Input_2.read();
	// Output_3.write(input_2_tmp); // rasterization2_m
	// Output_4.write(input_2_tmp); // rasterization2_m_1

	bit32 input_1_tmp, input_2_tmp;
	static int counter_1_1 = 0;
	static int counter_1_2 = 0;
	static int test = 1000;


    input_1_tmp = Input_1.read();
	if(counter_1_1 < test){ 
		counter_1_1 = counter_1_1 + 1;
		Output_1.write(input_1_tmp); // rasterization2_m
		Output_2.write(input_1_tmp); // rasterization2_m_1
	}
	else{
		Output_1.write(input_1_tmp); // rasterization2_m
	}

	input_2_tmp = Input_2.read();
	if(counter_1_2 < test){ 
		counter_1_2 = counter_1_2 + 1;
		Output_3.write(input_2_tmp); // rasterization2_m
		Output_4.write(input_2_tmp); // rasterization2_m_1
	}
	else{
		Output_3.write(input_2_tmp); // rasterization2_m
	}

	// if(Input_1.read_nb(input_1_tmp)){
	// 	Output_1.write(input_1_tmp); // rasterization2_m
	// 	Output_2.write(input_1_tmp); // rasterization2_m_1
	// }

	// if(Input_2.read_nb(input_2_tmp)){
	// 	Output_3.write(input_2_tmp); // rasterization2_m
	// 	Output_4.write(input_2_tmp); // rasterization2_m_1
	// }


	// if(Input_1.read_nb(input_1_tmp)){
	// 	if(!Output_1.full()){
	// 		Output_1.write(input_1_tmp); // rasterization2_m
	// 	}
	// 	if(!Output_2.full()){
	// 		Output_2.write(input_1_tmp); // rasterization2_m_1
	// 	}
	// }

	// if(Input_2.read_nb(input_2_tmp)){
	// 	if(!Output_3.full()){
	// 		Output_3.write(input_2_tmp); // rasterization2_m
	// 	}
	// 	if(!Output_4.full()){
	// 		Output_4.write(input_2_tmp); // rasterization2_m_1
	// 	}
	// }

	// input_1_tmp = Input_1.read();
	// if(!Output_1.full()){
	// 	Output_1.write(input_1_tmp); // rasterization2_m
	// 	if(!Output_2.full()){
	// 		Output_2.write(input_1_tmp); // rasterization2_m_1
	// 	}
	// }
	
	// input_2_tmp = Input_2.read();
	// if(!Output_3.full()){
	// 	Output_3.write(input_2_tmp); // rasterization2_m
	// 	if(!Output_4.full()){
	// 		Output_4.write(input_2_tmp); // rasterization2_m_1
	// 	}
	// }
}
