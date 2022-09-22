#include "../host/typedefs.h"

void tc_3_1 (
		hls::stream<ap_uint<32> > & Input_1,
		hls::stream<ap_uint<32> > & Input_2,
		hls::stream<ap_uint<32> > & Input_3,
		hls::stream<ap_uint<32> > & Input_4,
		hls::stream<ap_uint<32> > & Output_1,
		hls::stream<ap_uint<32> > & Output_2,
        hls::stream<ap_uint<32> > & Output_3
		)
{
#pragma HLS INTERFACE axis register port=Input_1
#pragma HLS INTERFACE axis register port=Input_2
#pragma HLS INTERFACE axis register port=Input_3
#pragma HLS INTERFACE axis register port=Input_4
#pragma HLS INTERFACE axis register port=Output_1 // Input_1
#pragma HLS INTERFACE axis register port=Output_2 // Input_3
#pragma HLS INTERFACE axis register port=Output_3 // winner

	bit32 input_1_tmp, input_2_tmp, input_3_tmp, input_4_tmp;

	static int counter_1_1 = 0;
	static int counter_1_2 = 0;
	static int counter_2_1 = 0;
	static int counter_2_2 = 0;

	static bool eval_1_done = false;
	static bool eval_2_done = false;

    // if num_inputs == 2, tc_1 receives 2 inputs(Input_1, Input_3) 
    // from regular operator and 2 inputs(Input_2, Input_4) from training operator
    // if num_inputs == 1, tc_1 receives 1 input(Input_1) from regular operator
    // and 1 input(Input_2) from training operator
    static int num_inputs = 1;

	if(Input_1.read_nb(input_1_tmp)){
		if(counter_1_1 < COUNTER){ 
			counter_1_1 = counter_1_1 + 1;
		}
		Output_1.write(input_1_tmp);
	}
	if(Input_3.read_nb(input_3_tmp)){
		if(counter_1_2 < COUNTER){ 
			counter_1_2 = counter_1_2 + 1;
		}
		Output_2.write(input_3_tmp);
	}

	if(Input_2.read_nb(input_2_tmp)){
		if(counter_2_1 < COUNTER){ 
			counter_2_1 = counter_2_1 + 1;
		}
	}
	if(Input_4.read_nb(input_4_tmp)){
		if(counter_2_2 < COUNTER){ 
			counter_2_2 = counter_2_2 + 1;
		}
	}

    int counter_1_sum = counter_1_1 + counter_1_2;
    int counter_2_sum = counter_2_1 + counter_2_2;

	if(counter_1_sum == COUNTER*num_inputs && eval_1_done == false){
		Output_3.write(1);
		eval_1_done = true;
	}
	else if(counter_2_sum == COUNTER*num_inputs && eval_2_done == false){
		Output_3.write(2);
		eval_2_done = true;
	}	

}
