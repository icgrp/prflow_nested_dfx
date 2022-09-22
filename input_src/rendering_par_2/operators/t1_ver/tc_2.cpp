#include "../host/typedefs.h"

void tc_2 (
		hls::stream<ap_uint<32> > & Input_1,
		hls::stream<ap_uint<32> > & Input_2,
		hls::stream<ap_uint<32> > & Output_1,
		hls::stream<ap_uint<32> > & Output_2		
		)
{
#pragma HLS INTERFACE axis register port=Input_1
#pragma HLS INTERFACE axis register port=Input_2
#pragma HLS INTERFACE axis register port=Output_1
#pragma HLS INTERFACE axis register port=Output_2

	bit32 input_1_tmp, input_2_tmp;

	static int counter_0 = 0;
	static int counter_1 = 0;
	static bit32 winner;
	static bool eval_done = false;
	static bool winner_sent = false;

	if(Input_1.read_nb(input_1_tmp)){
		if(counter_0 < COUNTER){ 
			counter_0 = counter_0 + 1;
		}
		Output_1.write(input_1_tmp);
	}

	if(Input_2.read_nb(input_2_tmp)){
		if(counter_1 < COUNTER){ 
			counter_1 = counter_1 + 1;
		}
		counter_1 = counter_1 + 1;
	}

	// evaluation done, enter only once
	if( (counter_0 == COUNTER || counter_1 == COUNTER) && (eval_done == false)){
		if(counter_0 == COUNTER){
			winner = 1;
		}
		else{
			winner = 2;
		}
		eval_done = true;
	}

	// both finished, enter only once
	if((counter_0 + counter_1 == 2*COUNTER) && (winner_sent == false)){ 
		Output_2.write(winner);
		winner_sent = true;
	}

}
