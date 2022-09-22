#include "../host/typedefs.h"

void t2c_2 (
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

	static int counter_0 = 0;
	static int counter_1 = 0;
	static bit32 winner;
	static bool eval_done = false;
	static bool winner_sent = false;

    // if num_inputs == 2, t2c_1 receives 2 inputs(Input_1, Input_3) 
    // from regular operator and 2 inputs(Input_2, Input_4) from training operator
    // if num_inputs == 1, t2c_1 receives 1 input(Input_1) from regular operator
    // and 1 input(Input_2) from training operator
    static int num_inputs = 2;
    // if(num_inputs == 0){
    //     num_inputs = Input_5.read();
    // }

	if(Input_1.read_nb(input_1_tmp)){
		if(counter_0 < COUNTER*num_inputs){ 
			counter_0 = counter_0 + 1;
		}
		Output_1.write(input_1_tmp);
	}
	else if(Input_3.read_nb(input_3_tmp)){
		if(counter_0 < COUNTER*num_inputs){ 
			counter_0 = counter_0 + 1;
		}
		Output_2.write(input_3_tmp);
	}
	
	if(Input_2.read_nb(input_2_tmp)){
		if(counter_1 < COUNTER*num_inputs){ 
			counter_1 = counter_1 + 1;
		}
		counter_1 = counter_1 + 1;
	}
	else if(Input_4.read_nb(input_4_tmp)){
		if(counter_1 < COUNTER*num_inputs){ 
			counter_1 = counter_1 + 1;
		}
		counter_1 = counter_1 + 1;
	}

	// evaluation done, enter only once
	if((counter_0 == COUNTER*num_inputs || counter_1 == COUNTER*num_inputs) && \
                                                        (eval_done == false)){
		if(counter_0 == COUNTER*num_inputs){
			winner = 1;
		}
		else{
			winner = 2;
		}
		eval_done = true;
	}

	//  finished, enter only once
	if((counter_0 + counter_1 == 2*num_inputs*COUNTER) && (winner_sent == false)){ 
		Output_3.write(winner);
		winner_sent = true;
	}

}
